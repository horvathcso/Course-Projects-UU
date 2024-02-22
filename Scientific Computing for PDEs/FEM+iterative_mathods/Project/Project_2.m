clc; clear; 
%
%%%%%%%%% Problem B.1 %%%%%%%%%%%
%

%     A = [10, -1, 2, 0;
%         -1, 11, -1, 3;
%         2, -1, 10, -1;
%         0, 3, -1, 8];
% 
%     b = [6, 25, -11, 15]';
%     TOL = 0.001;
%     
%     tic;
%     result_jacobi = jacobi(A,b,TOL);
%     toc
%     
%     tic;
%     result_gs = gs(A, b, TOL);
%     toc
% 
%     tic; 
%     result_CG = CG(A, b, TOL);
%     toc
% 
%     tic; 
%     result_myownLU = myownLU(A,b,TOL);
%     toc
% 
%     tic; 
%     result_back = A\b;
%     toc
% 
%     tic;
%     [L,U] = lu(A); 
%      y = L\b; 
%      resultLU=U\y; 
%     toc 

%
%%%%%%%%%% Problem B.2 %%%%%%%%%%%%%
%   



TOL = 1e-5;
N = [100 500 1000] ; % the size of the linear system
result = zeros(3 ,6);
w = 5; % the diagonal weight

for i = 1:3
    A = rand (N(i)) + diag (w* ones (N(i) ,1));
    b = rand (N(i) ,1);

    x=all((2*abs(diag(A)))- sum(abs(A),2)>=0); %sum(abs(A),2) will perform addition row wise
    if x==0
        disp('Matrix is not Diagonal Dominant Row wise')
    else
        disp('Matrix is Diagonal Dominant Row wise')
    end
    

%     tic;
%     result_jacobi = jacobi(A,b,TOL);
%     result(i,1) = toc;
% 
    tic;
    result_gs = gs(A, b, TOL);
    result(i,2) = toc;


% 
%     tic;
%     result_CG = CG(A, b, TOL);
%     result(i,3) = toc;
%     
%     tic;
%     result_myownLU = myownLU(A,b,TOL);
%     result(i,4) = toc;
%     
    tic;
    resultbacks = A\b;
    result(i, 5) = toc;

%     norm(resultbacks-result_jacobi)
%     norm(resultbacks-result_CG)
%     
%     tic;
%     [L,U] = lu(A);
%     y = L\b;
%     resultLU=U\y;
%     result(i, 6) = toc;       
end

   result;

%
%%%%%%%%%% B.3 %%%%%%%%%%%
%

alpha = [0 0.1 0.001 0.00001];
m = 10000;
Q = eye(m);
N = m;
for i =1:m-1
    Q(i,i) = 2 + alpha(1);
    Q(i+1,i) = -1;
    Q(i,i+1) = -1;
end
Q(m,m) = 2 + alpha(1);
b = rand(N,1);
result2 = zeros(1 ,6);
% 
%     tic;
%     result_jacobi = jacobi(Q,b,TOL);
%     result2(1,1) = toc;
% 
%     tic;
%     result_gs = gs(Q, b, TOL);
%     result2(1,2) = toc;

%     cond(Q)

%     tic;
%     result_CG = CG(Q, b, TOL);
%     result2(1,3) = toc;

%     tic; 
%     result_myownLU = myownLU(Q,b,TOL);
%     result2(1, 4) = toc;
% 
%     tic;
%     resultbacks = Q\b;
%     result2(1, 5) = toc;
% 
%     tic;
%     [L,U] = lu(Q);
%     y = L\b;
%     resultLU=U\y;
%     result2(1, 6) = toc;     

