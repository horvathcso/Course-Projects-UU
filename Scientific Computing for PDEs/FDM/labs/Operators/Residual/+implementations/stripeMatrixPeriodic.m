% Creates a periodic discretization matrix of size n x n
%  with the values of val on the diagonals diag.
%   A = stripeMatrix(val,diags,n)
function A = stripeMatrixPeriodic(val,diags,n)

    D = ones(n,1)*val;
    A = spdiagsPeriodic(D,diags);
end

function A = spdiagsPeriodic(vals,diags)
    % Creates an m x m periodic discretization matrix.
    % vals - m x ndiags matrix of values
    % diags - 1 x ndiags vector of the 'center diagonals' that vals end up on
    % vals that are not on main diagonal are going to spill over to
    % off-diagonal corners.
    [m, ~] = size(vals);

    A = sparse(m,m);

    for i = 1:length(diags)

        d = diags(i);
        a = vals(:,i);

        % Sub-diagonals
        if d < 0
            a_bulk = a(1+abs(d):end);
            a_corner = a(1:1+abs(d)-1);
            corner_diag = m-abs(d);
            A = A + spdiagVariable(a_bulk, d);
            A = A + spdiagVariable(a_corner, corner_diag);

        % Super-diagonals
        elseif d > 0
            a_bulk = a(1:end-d);
            a_corner = a(end-d+1:end);
            corner_diag = -m + d;
            A = A + spdiagVariable(a_bulk, d);
            A = A + spdiagVariable(a_corner, corner_diag);

        % Main diagonal
        else
             A = A + spdiagVariable(a, 0);
        end

    end

end

function A = spdiagVariable(a,i)
    default_arg('i',0);

    if isrow(a)
        a = a';
    end

    n = length(a)+abs(i);

    if i > 0
        a = [sparse(i,1); a];
    elseif i < 0
        a = [a; sparse(abs(i),1)];
    end

    A = spdiags(a,i,n,n);
end
