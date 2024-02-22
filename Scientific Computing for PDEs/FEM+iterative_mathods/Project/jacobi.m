function x = jacobi(A,b,TOL)
    x = ones(1,length(b))';
    x_old = zeros(1,length(b))';
    iter_jacobi = 0; 
    r_norm = norm(b-A*x);
   
    while r_norm > TOL %norm(x-x_old) > TOL
        x_old = x;
        sigma = zeros(length(b),1);
        iter_jacobi = iter_jacobi +1;
           for i = 1:length(b)
               for j = 1:length(b)
                   sigma(i) = sigma(i) + (A(i, j)*x(j)); %uses recent x, change to old right now its GS method
               end  
           end
           
           for k = 1:length(b)
               x(k) = 1/A(k,k) *(b(k)-sigma(k))+x(k);
           end
           r_norm = norm(b-A*x);
    end
    iter_jacobi
end

