% Solves the soap film problem on the unit square. Stops at different
% points depending on the number of out parameters.
%
% Input: Nx, Ny the number of interior points in the x- and y-directions.
%
% Output: A the coefficient matrix for the linear system
%         b the right hand side of the linear system
%         x,y the coordinates of the grid
%         u the solution.
%
% If the solution is computed it is also plotted.
%
function [A,b,x,y,u]=soapfilm(Nx,Ny)
  %
  % The domain is the unit square
  %
  Lx = 1;
  Ly = 1;
  %
  % Discretize in the x and y-directions. Nx,Ny interior points  
  %
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
  %
  gamma = (hx/hy)^2;
  D0=-2*(1+gamma)*speye(Nx);
  for j=1:Nx-1
    D0(j,j+1) = 1;
    D0(j+1,j) = 1;
  end
  %
  % Upper and lower diagonal blocks
  %
  D1 = gamma*speye(Nx);
  %
  % Fill the matrix with the blocks Ny x Ny blocks
  % Sparse storage. Use a Kronecker product. 
  %
  K0 = speye(Ny);
  K1 = spalloc(Ny,Ny,2*(Ny-1));
  for j=1:Ny-1
    K1(j,j+1) = 1;
    K1(j+1,j) = 1;
  end  

  A = kron(K0,D0) + kron(K1,D1); % Otroligt mycket snabbare.

%  A = spalloc(Nx*Ny,Nx*Ny,5*Nx*Ny);
%  for j=1:Ny
%    A((j-1)*Nx+1:j*Nx,(j-1)*Nx+1:j*Nx) = D0;
%  end   
%  for j=1:Ny-1
%    A((j-1)*Nx+1:j*Nx,j*Nx+1:(j+1)*Nx) = D1;
%    A(j*Nx+1:(j+1)*Nx,(j-1)*Nx+1:j*Nx) = D1;
%  end

  if (nargout >= 2) % Checking the number of out parameters
    %  
    % Compute the right hand side b
    %
    b=zeros(Nx*Ny,1);
    %
    % First row, y=0 comes in
    %
    b(1:Nx,1) = -gamma^2*g(x(2:end-1),0);
    %
    % Last row, y=1 comes in
    %
    b((Ny-1)*Nx+1:Ny*Nx,1) = -gamma^2*g(x(2:end-1),1);
    %
    % Every row, x=0, x=1 comes in for first and last position
    %
    for r=1:Ny
      b((r-1)*Nx+1,1) = b((r-1)*Nx+1,1) - g(0,y(r+1));
      b(r*Nx,1) = b(r*Nx,1) - g(1,y(r+1));
    end  
  end
  
  if (nargout>=5) % Compute and plot the solution
    u = A\b;
    plotsol(x,y,u);
  end

function g=g(x,y)
  %
  % Different values for the four sides  
  %
  if (x==0)
    g = abs(cos(2*pi*y(:)) + 0.5); % sin(2*pi*y(:));
  elseif (x==1)
    g = abs(cos(2*pi*y(:)) + 0.5); % sin(2*pi*3*y(:))+4*y(:).*(y(:)-1);
  elseif (y==0)
    g = abs(cos(2*pi*x(:)) + 0.5); % sin(2*pi*8*x(:));
  elseif (y==1)
    g = abs(cos(2*pi*x(:)) + 0.5); % sin(2*pi*4*x(:)) + sin(2*pi*x(:));
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
  
  fig = input('Give figure number for 2D-plot, 0=no plot > ');
  if (fig>0)
    %
    % Clear figure window 
    %
    figure(fig),clf
    %
    umi=min(min(u));
    uma=max(max(u));
    v=[umi:(uma-umi)/50:uma];
  
    [C,H,CF]=contourf(x,y,u,v);
    set(H,'EdgeColor','none')
    set(gca,'FontSize',18)
    xlabel('x')
    ylabel('y')
    axis square 
    colorbar
  end

  fig = input('Give figure number for 3D-plot, 0=no plot > ');  
  if (fig>0)
    figure(fig),clf
    H=surf(x,y,u);
    set(H,'EdgeColor','none')
    colorbar
    set(gca,'FontSize',18)
    xlabel('x')
    ylabel('y')
  end