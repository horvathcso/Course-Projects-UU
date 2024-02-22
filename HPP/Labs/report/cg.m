function x = cg(A,b,TOL)

    x = ones(length(b),1);
    r = b - A*x; 
    p_old = r;
    x_old = zeros(1,length(b))';
    iter_CG = 0; 


    iter_CG = iter_CG +1; 
        alpha = (r'*r)/(r'*A*r);
        x = x + alpha*r;
        r = b-A*x;
     

    while norm(x-x_old) > TOL 
        iter_CG = iter_CG +1; 
        x_old = x;
        gamma = -(p_old'*A*r)/(p_old'*A*p_old);
        p_new = r + gamma*p_old;
        alpha = (p_new'*r)/(p_new'*A*p_new);
        x = x + alpha*p_new;
        r = r - alpha*A*p_new;
        p_old = p_new;
    end
    fprintf ( ' cg took % g iteration \n ' , iter_CG );
%}
end