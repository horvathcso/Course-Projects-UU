function [H, Q, M] = Periodic_E_SC_Variable_2(m,h)
    % m = number of unique grid points, i.e. h = L/m;

    if(m<3)
        error(['Operator requires at least ' num2str(3) ' grid points']);
    end

    % H
    Hv = ones(m,1);
    Hv = h*Hv;
    H = spdiag(Hv, 0);

    % Q
    diags   = -1:1;
    stencil = [-1/2 0 1/2];
    Q = stripeMatrixPeriodic(stencil, diags, m);
    
    % M
    scheme_width = 3;
    scheme_radius = (scheme_width-1)/2;

    r = 1:m;
    offset = scheme_width;
    r = r + offset;
    function M = M_fun(c)
        c = [c(end-scheme_width+1:end); c; c(1:scheme_width) ];

        Mm1 = -c(r-1)/2 - c(r)/2;
        M0  =  c(r-1)/2 + c(r)   + c(r+1)/2;
        Mp1 =            -c(r)/2 - c(r+1)/2;

        vals = [Mm1,M0,Mp1];
        diags = -scheme_radius : scheme_radius;
        M = 1/h*spdiagsPeriodic(vals,diags);
    end
    M = @M_fun;
end