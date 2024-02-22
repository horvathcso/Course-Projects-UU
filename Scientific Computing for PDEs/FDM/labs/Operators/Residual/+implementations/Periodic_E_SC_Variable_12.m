function [H, Q, M] = Periodic_E_SC_Variable_12(m,h)
    if(m<13)
        error(['Operator requires at least ' num2str(8) ' grid points']);
    end

    % Norm
    Hv = ones(m,1);
    Hv = h*Hv;
    H = spdiag(Hv, 0);

    % Q and D1 operator
    diags   = -6:6;
    stencil = [1/5544, -1/385, 1/56, -5/63, 15/56, -6/7, 0, 6/7, -15/56, 5/63, -1/56, 1/385, -1/5544];
    Q = stripeMatrixPeriodic(stencil, diags, m);
    D1 = 1/h*Q;

    % Undivided differences      
    % diags   = -4:3;
    % stencil = [-1 7 -21 35 -35 21 -7 1];
    % DD_7 = stripeMatrixPeriodic(stencil, diags, m);

    % diags   = -4:4;
    % stencil = [1 -8 28 -56 70 -56 28 -8 1];
    % DD_8 = stripeMatrixPeriodic(stencil, diags, m);

    % diags   = -5:4;
    % stencil = [-1 9 -36 84 -126 126 -84 36 -9 1];
    % DD_9 = stripeMatrixPeriodic(stencil, diags, m);
    
    % diags   = -5:5;
    % stencil = [1 -10 45 -120 210 -252 210 -120 45 -10 1];
    % DD_10 = stripeMatrixPeriodic(stencil, diags, m);

    % diags   = -6:5;
    % stencil = [-1, 11, -55, 165, -330, 462, -462, 330, -165, 55, -11, 1];
    % DD_11 = stripeMatrixPeriodic(stencil, diags, m);

    % diags   = -6:6;
    % stencil = [1, -12, 66, -220, 495, -792, 924, -792, 495, -220, 66,-12, 1];
    % DD_12 = stripeMatrixPeriodic(stencil, diags, m);

    % M operator
    function M = M_fun(c)

        % diags   = -1:0;
        % stencil = [1/2, 1/2];
        % C2 = stripeMatrixPeriodic(stencil, diags, m);

        % diags   = -1:1;
        % stencil = [5/18, 4/9, 5/18];
        % C3 = stripeMatrixPeriodic(stencil, diags, m);

        % diags   = -2:1;
        % stencil = [5/28, 9/28, 9/28, 5/28];
        % C4 = stripeMatrixPeriodic(stencil, diags, m);

        % diags   = -2:2;
        % stencil = [1/7, 8/35, 9/35, 8/35, 1/7];
        % C5 = stripeMatrixPeriodic(stencil, diags, m);

        % diags   = -3:2;
        % stencil = [1/6, 1/6, 1/6, 1/6, 1/6, 1/6];
        % C6 = stripeMatrixPeriodic(stencil, diags, m);

        C1 = sparse(diag(c));
        % C2 = sparse(diag(C2 * c));
        % C3 = sparse(diag(C3 * c));
        % C4 = sparse(diag(C4 * c));

        % Remainder term added to wide second derivative operator
        % R = (1/30735936 / h) * transpose(DD_12) * C1 * DD_12 + (1/6403320 / h) * transpose(DD_11) * C2 * DD_11 + (1/1293600 / h) * transpose(DD_10) * C3 * DD_10 + (1/249480 / h) * transpose(DD_9) * C4 * DD_9 + (1/44352 / h) * transpose(DD_8) * C5 * DD_8 + (1/6468 / h) * transpose(DD_7) * C6 * DD_7;
        M = -(Q * C1 * D1);
    end
    M = @M_fun;


end
