function my_first_fem_solver_modP4()
a = 0 % left end point of interval
b = 1 % right
N = 5 % number of intervals
h = 1/256%(b-a)/N % mesh size
x = a:h:b; % node coords
A=my_stiffness_matrix_assembler(x);
B=my_load_vector_assembler(x, 0, 0);
xi = A\B; % solve system of equations
plot(x,xi) % plot solution
disp(cond(A));
%v=xi- (x.*(1-x))';
%err=norm(v);
%disp(['The numerical error is: ' , num2str(err)]);
end

function A=my_stiffness_matrix_assembler(x)
%
% Returns the assembled stiffness matrix A.
% Input is a vector x of node coords.
%
N = length(x) - 1; % number of elements
A = zeros(N+1, N+1); % initialize stiffnes matrix to zero   
for i = 1:N % loop over elements
h = x(i+1) - x(i); % element length
n = [i i+1]; % nodes
A(n,n) = A(n,n) + [1 -1; -1 1]/h; % assemble element stiffness
end
A(1,1) = 1; % adjust for BC
A(1,2) = 0;
A(N+1,N+1) = 1;
A(N+1,N) = 0;
end

function B=my_load_vector_assembler(x, g_l, g_r)
%
% Returns the assembled load vector b.
% Input is a vector x of node coords.
%
N = length(x) - 1; B = zeros(N+1, 1); 
for i = 1:N
h = x(i+1) - x(i);
n = [i i+1];
B(n) = B(n) + [f(x(i)); f(x(i+1))]*h/2;
end
B(1)=g_l;
B(N+1)=g_r;
end

function fx = f(x)
%def f
fx=2;
end