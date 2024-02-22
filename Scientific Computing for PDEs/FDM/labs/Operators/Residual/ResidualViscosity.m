classdef ResidualViscosity < handle
    properties
        D % difference operator for flux
        bdf % backward difference formula
        C_first % Compounded cofficients for first order viscisity
        C_res % Compounded cofficients for residual order viscisity
        V_prev % Previous stages of solution vector. Used for bdf
    end

    methods
        function obj = ResidualViscosity(L, n, order_flux, order_bdf, dt, Cmax, Cres)
            [H, Q] = Periodic_E_SC_Variable(L,n,order_flux);
            S = Periodic_AD_SC(L,n,order_flux);
            obj.D = H\(Q-S);
            h = L/n;
            obj.bdf = BDF(order_bdf, dt);
            obj.C_first = Cmax*h;
            obj.C_res = Cres*h^2;
            obj.V_prev = [];
        end

        % Computes the residual viscosity for solution vector V. Also stores
        % V for future evaluation. 
        % Important: Calling eval again prior to advancing 1 time-step dt
        % will result in an erroneous residual calculation!
        function visc = eval(obj, V)
            visc_first = obj.visc_first_order(V);
            if size(obj.V_prev,2) < obj.bdf.order % Not enough stages to compute BDF
                visc_res = 0*V;
                % Accumulate solution vector for BDF
                obj.V_prev = [V, obj.V_prev];
            else
                visc_res = obj.visc_residual(V);
                % Update previous
                obj.V_prev(:,2:end) = obj.V_prev(:,1:end-1);
                obj.V_prev(:,1) = V;
            end
            visc = min(visc_first, visc_res);
        end

        % Computes the first order viscosity
        function visc_first = visc_first_order(obj, V)
            visc_first = obj.C_first*abs(V);
        end

        % Computes the residual viscosity based on the residual
        % res = dVdT + dF. The components dVdT, and dF are returned
        % for plotting.
        function [visc_res, dVdt, dF] = visc_residual(obj, V)
            dVdt = obj.bdf.eval(V,obj.V_prev);
            dF = obj.D*(V.^2/2);
            res = dVdt + dF;
            visc_res = movmax(obj.C_res*abs(res)./obj.normalization(V),3);
        end

        function n = normalization(obj,V)
            n = abs(obj.minmaxDiffNeighborhood(V)-norm(V-mean(V),inf));
        end
        
        function minmaxDiff = minmaxDiffNeighborhood(obj,V)
            Vmax = movmax(V,3);
            Vmin = movmin(V,3);
            minmaxDiff = Vmax - Vmin;
        end

    end
end