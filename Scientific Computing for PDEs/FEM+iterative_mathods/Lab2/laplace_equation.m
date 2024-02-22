function laplace_equation(N, method)
%
% laplace_equation(N, method)
%   N      : number of interior grid points in each dimension     
%   method : 'jacobi', 'gauss-seidel', or 'conjugate-gradient'
% 
% Press space/enter to iterate, Ctrl-C to break.
% 

  maxiter = 100;	 
  Nx = N;
  Ny = N;
  
  % The domain is the unit square
  Lx = 1; Ly = 1;   
  % Discretize in the x and y-directions. Nx,Ny interior points  
  hx = Lx/(Nx+1);
  hy = Ly/(Ny+1);
  x = 0:hx:Lx;
  y = 0:hy:Ly;
  %
  % Use D+D- in both directions. Order unknowns row by row.
  % Multiply by hx^2. Stencil:
  %
  %      (hx/hy)^2
  % 1 -2(1+(hx/hy)^2) 1
  %      (hx/hy)^2
  %
  % Diagonal block, size Nx x Nx
  gamma = (hx/hy)^2;
  D0=-2*(1+gamma)*speye(Nx);
  for j=1:Nx-1
    D0(j,j+1) = 1;
    D0(j+1,j) = 1;
  end
  % Upper and lower diagonal blocks
  D1 = gamma*speye(Nx);
  % Fill the matrix with the blocks Ny x Ny blocks
  % Sparse storage. Use a Kronecker product. 
  K0 = speye(Ny);
  K1 = spalloc(Ny,Ny,2*(Ny-1));
  for j=1:Ny-1
    K1(j,j+1) = 1;
    K1(j+1,j) = 1;
  end  

  A = kron(K0,D0) + kron(K1,D1); % Otroligt mycket snabbare.

  % Compute the right hand side b
  b=zeros(Nx*Ny,1);
  % First row, y=0 comes in
  b(1:Nx,1) = -gamma^2*g(x(2:end-1),0);
  % Last row, y=1 comes in
  b((Ny-1)*Nx+1:Ny*Nx,1) = -gamma^2*g(x(2:end-1),1);
  % Every row, x=0, x=1 comes in for first and last position
  for r=1:Ny
    b((r-1)*Nx+1,1) = b((r-1)*Nx+1,1) - g(0,y(r+1));
    b(r*Nx,1) = b(r*Nx,1) - g(1,y(r+1));
  end  

  % Now we have A and b
  u = zeros(Nx*Ny,1);
  switch(lower(method))
    case {'jacobi','j'}
      fprintf('=== Jacobi === (Press enter to iterate)\n');
      Dinv = diag(1./diag(A));
      L = tril(A,-1);
      U = triu(A,1);
      for iter = 1:maxiter
	fprintf('Iteration Count: %5d, Residual: %5.3f\n',iter, norm(A*u-b))
        plotsol(x,y,u)
        u = Dinv*(b-(L+U)*u);
	pause
      end
    case {'gauss-seidel', 'gs'}
      fprintf('=== Gauss-Seidel === (Press enter to iterate)\n');
      D = diag(diag(A));
      L = tril(A,-1);
      U = triu(A,1);
      for iter = 1:maxiter
	fprintf('Iteration Count: %5d, Residual: %5.3f\n',iter, norm(A*u-b))
        plotsol(x,y,u)
	v = b - U*u;
	u = (D+L)\v;
	pause
      end      		
    case {'conjugate-gradient','cg'}
      fprintf('=== Conjugate-Gradient === (Press enter to iterate)\n');
      r = b;
      rho = norm(r)^2;
      p = r;
      for iter = 1:maxiter
	fprintf('Iteration Count: %5d, Residual: %5.3f\n',iter, norm(A*u-b))
        plotsol(x,y,u)
	w = A*p;
	alpha = rho/(p'*w);
	u = u + alpha*p;
	r = r - alpha*w;
	rho_prev = rho;
	rho = norm(r)^2;
	p = r + (rho/rho_prev)*p;
	pause
      end
    otherwise
      error(['Unknown method "' method '"'])
  end

function g=g(x,y)
  %
  % Different values for the four sides  
  %
  if (x==0)
    g = y(:);
%    g = abs(cos(2*pi*y(:)) + 0.5); % sin(2*pi*y(:));
  elseif (x==1)
  g = y(:);
%    g = abs(cos(2*pi*y(:)) + 0.5); % sin(2*pi*3*y(:))+4*y(:).*(y(:)-1);
  elseif (y==0)
    g = sin(2*pi*x(:));
%    g = abs(cos(2*pi*x(:)) + 0.5); % sin(2*pi*8*x(:));
  elseif (y==1)
    g = cos(2*pi*x(:));
%    g = abs(cos(2*pi*x(:)) + 0.5); % sin(2*pi*4*x(:)) + sin(2*pi*x(:));
  end  


function plotsol(x,y,u)
  %
  % Row by row ordering --> matrix u  
  %  
  u = reshape(u,length(x)-2,length(y)-2)';
  %
  % Insert the boundary values given by the function g
  %
  u = [g(x,0)';
       g(0,y(2:end-1)) u g(1,y(2:end-1));
       g(x,1)'];
  mesh(x,y,u);

