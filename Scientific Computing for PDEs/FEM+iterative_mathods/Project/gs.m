function x = gs(A,b,TOL)
    x = ones(1,length(b))';
    x_old = zeros(1,length(b))';
    iter_gs = 1;
    r_norm = norm(b-A*x);
    while r_norm > TOL %norm(x-x_old) > TOL
       x_old = x;
       iter_gs = iter_gs +1; 
       for i = 1:length(b)
           sigma = 0;
           for j = 1:length(b)
               if (j ~= i)
                   sigma = sigma + A(i, j)*x(j);
               end  
           end
           x(i) = 1/A(i,i) *(b(i)-sigma);
           r_norm = norm(b-A*x);
       end
    end
    iter_gs
end

