function x = myownLU(A,b,TOL)
    
    %Doolittle algorithm for LU decomposition

    [m n] = size(A);
    L = zeros(m);
    U = zeros(m);
    %Decompose L & U
    U(1,:) = A(1,:);
    L(:,1)= A(:,1)/U(1,1);
    L(1,1) = 1;
    for h=2:m
        for i=2:m
            for j =2:m
            U(i,j) = A(i,j) - L(i,1:i-1)*U(1:i-1,j);
            end
            L(i,h) = A(i,h) - L(i,1:h-1)*U(1:h-1,h);
            L(i,h) = L(i,h)/U(h,h);
        end
    end
    %Forward  substitution
    y = zeros(n);
    y(1,1) = b(1)./L(1,1);
    for i = 2:n
        y(i, 1) = b(i) - L(i, 1:i-1)*y(1:i-1, 1);
        y(i, 1) = y(i, 1)./L(i,i);
    end

    %Backward substitution
    x = zeros(n);
    x(n,1) = y(n)/U(n,n);
    for i = n-1:-1:1
        x(i,:) = y(i, :) - U(i,i+1:n)*x(i+1:n,:);
        x(i,:) = x(i,:)/U(i,i);
    end
    x = x(:,1);
end