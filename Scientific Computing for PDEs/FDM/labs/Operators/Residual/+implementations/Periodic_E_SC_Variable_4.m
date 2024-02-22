function [H, Q, M] = Periodic_E_SC_Variable_4(m,h)
    % m = number of unique grid points, i.e. h = L/m;

    if(m<5)
        error(['Operator requires at least ' num2str(5) ' grid points']);
    end

    % H
    Hv = ones(m,1);
    Hv = h*Hv;
    H = spdiag(Hv, 0);

    % Q
    stencil = [1/12 -2/3 0 2/3 -1/12];
    diags = -2:2;
    Q = stripeMatrixPeriodic(stencil, diags, m);
    
    % M
    scheme_width = 5;
    scheme_radius = (scheme_width-1)/2;

    r = 1:m;
    offset = scheme_width;
    r = r + offset;
    function M = M_fun(c)
        c = [c(end-scheme_width+1:end); c; c(1:scheme_width) ];

        % Note: these coefficients are for -M.
        Mm2 = -1/8*c(r-2) + 1/6*c(r-1) - 1/8*c(r);
        Mm1 = 1/6 *c(r-2) + 1/2*c(r-1) + 1/2*c(r) + 1/6*c(r+1);
        M0  = -1/24*c(r-2)- 5/6*c(r-1) - 3/4*c(r) - 5/6*c(r+1) - 1/24*c(r+2);
        Mp1  = 0 * c(r-2) + 1/6*c(r-1) + 1/2*c(r) + 1/2*c(r+1) + 1/6 *c(r+2);
        Mp2  = 0 * c(r-2) + 0 * c(r-1) - 1/8*c(r) + 1/6*c(r+1) - 1/8 *c(r+2);

        vals = -[Mm2,Mm1,M0,Mp1,Mp2];
        diags = -scheme_radius : scheme_radius;
        M = 1/h*spdiagsPeriodic(vals,diags);
    end
    M = @M_fun;
end