function [H, Q, M] = Periodic_E_SC_Variable_6(m,h)
    % m = number of unique grid points, i.e. h = L/m;

    if(m<7)
        error(['Operator requires at least ' num2str(7) ' grid points']);
    end

    % H
    Hv = ones(m,1);
    Hv = h*Hv;
    H = spdiag(Hv, 0);

    % Q
    diags   = -3:3;
    stencil = [-1/60 9/60 -45/60 0 45/60 -9/60 1/60];
    Q = stripeMatrixPeriodic(stencil, diags, m);

    % M
    scheme_width = 7;
    scheme_radius = (scheme_width-1)/2;
    r = 1:m;
    offset = scheme_width;
    r = r + offset;

    function M = M_fun(c)
        c = [c(end-scheme_width+1:end); c; c(1:scheme_width) ];

        Mm3 =  c(r-2)/0.40e2 + c(r-1)/0.40e2 - 0.11e2/0.360e3 * c(r-3) - 0.11e2/0.360e3 * c(r);
        Mm2 =  c(r-3)/0.20e2 - 0.3e1/0.10e2 * c(r-1) + c(r+1)/0.20e2 + 0.7e1/0.40e2 * c(r) + 0.7e1/0.40e2 * c(r-2);
        Mm1 = -c(r-3)/0.40e2 - 0.3e1/0.10e2 * c(r-2) - 0.3e1/0.10e2 * c(r+1) - c(r+2)/0.40e2 - 0.17e2/0.40e2 * c(r) - 0.17e2/0.40e2 * c(r-1);
        M0 =  c(r-3)/0.180e3 + c(r-2)/0.8e1 + 0.19e2/0.20e2 * c(r-1) + 0.19e2/0.20e2 * c(r+1) + c(r+2)/0.8e1 + c(r+3)/0.180e3 + 0.101e3/0.180e3 * c(r);
        Mp1 = -c(r-2)/0.40e2 - 0.3e1/0.10e2 * c(r-1) - 0.3e1/0.10e2 * c(r+2) - c(r+3)/0.40e2 - 0.17e2/0.40e2 * c(r) - 0.17e2/0.40e2 * c(r+1);
        Mp2 =  c(r-1)/0.20e2 - 0.3e1/0.10e2 * c(r+1) + c(r+3)/0.20e2 + 0.7e1/0.40e2 * c(r) + 0.7e1/0.40e2 * c(r+2);
        Mp3 =  c(r+1)/0.40e2 + c(r+2)/0.40e2 - 0.11e2/0.360e3 * c(r) - 0.11e2/0.360e3 * c(r+3);

        vals = [Mm3,Mm2,Mm1,M0,Mp1,Mp2,Mp3];
        diags = -scheme_radius : scheme_radius;
        M = 1/h*spdiagsPeriodic(vals,diags);
    end
    M = @M_fun;


end
