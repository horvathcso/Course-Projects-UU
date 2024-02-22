%% Given parameters
T=1;
CFL = 0.1;
r0 = 0.25;
x1_0 = 0.3;
x2_0 = 0;

%Used geometry
g = @circleg ;


%% Problem 1 - Numerical solution
%hmax values to run the simulation for
hmax_list = [1/8,1/32];
initial_data = [1, 2];

%Iteration on possible hmax values
for init = initial_data
for hmax = hmax_list
    %mesh data
    [p ,e , t ] = initmesh (g , 'hmax' , hmax); %function call to create mesh
    x1=p(1,:)'; % vector of x1 coordinates 
    x2=p(2,:)'; % vector of x2 coordinates

    % Set up the matrices
    df=ddf(x1,x2)';
    M = MassAssembler2D(p,t);
    C = ConvectionAssembler2D(p,t,df(1,:),df(2,:));

    %Initial setup
    
    if init==1
    U_0 = 1 / 2 * (1 - tanh((((x1 - x1_0).^2 + (x2 - x2_0).^2) / (r0^2)) - 1));
    elseif init==2
    U_00 = ((x1 - x1_0).^2 + (x2 - x2_0).^2) <r0^2;
    U_0=double(U_00);
    end
    
    U = U_0;

    %Time integration Crank-Nicholson
    time = 0;
    inf_norm = max(abs(df(1,:))+abs(df(2,:)));
    kn = CFL * hmax/inf_norm*1.0; % timstep - not depends on U_n due to f'

    while time<T
        %Set up equation matrix / vector
        A=((M/kn) + (C/2));
        b=((M/kn) * U - (C/2) * U);
        
        %Boundary conditions
        I = eye( length ( p ));
        A(e(1,:) ,:) =I(e(1,:) ,:);
        b(e(1,:)) = 0;
        
        %Solve equation
        U = A\b;

        time = time + kn;
    end

    
    %Plot solution
    figure()    
    pdeplot(p,e,t,"XYData",U,'Zdata',U);
    title("Solution at T="+T+", hmax="+hmax)
end
end

%% Problem 2 -Error estimates
%hmax values to run the simulation for
hmax_list = [1/4, 1/8, 1/16, 1/32];
initial_data = [1, 2];

%Iteration on possible hmax values

for init = initial_data
i=1;
for hmax = hmax_list
    %mesh data
    [p ,e , t ] = initmesh (g , 'hmax' , hmax); %function call to create mesh
    x1=p(1,:)'; % vector of x1 coordinates 
    x2=p(2,:)'; % vector of x2 coordinates

    % Set up the matrices
    df=ddf(x1,x2)';
    M = MassAssembler2D(p,t);
    C = ConvectionAssembler2D(p,t,df(1,:),df(2,:));

    %Initial setup
    
    if init==1
    U_0 = 1 / 2 * (1 - tanh((((x1 - x1_0).^2 + (x2 - x2_0).^2) / (r0^2)) - 1));
    elseif init==2
    U_00 = ((x1 - x1_0).^2 + (x2 - x2_0).^2) <r0^2;
    U_0=double(U_00);
    end

    U=U_0;

    %Time integration Crank-Nicholson
    time = 0;
    inf_norm = max(abs(df(1,:))+abs(df(2,:)));
    kn = CFL * hmax/inf_norm*1.0; % timstep - not depends on U_n due to f'

    while time<T
        %Set up equation matrix / vector
        A=((M/kn) + (C/2));
        b=((M/kn) * U - (C/2) * U);
        
        %Boundary conditions
        I = eye( length ( p ));
        A(e(1,:) ,:) =I(e(1,:) ,:);
        b(e(1,:)) = 0;
        
        %Solve equation
        U = A\b;

        time = time + kn;
    end

    
    %Plot solution
    figure()    
    pdeplot(p,e,t,"XYData",U,'Zdata',U);
    title("Solution at T="+T+", hmax="+hmax)

    %Error
    error=U-U_0;
    L2E(i)=sqrt(error'*M*error);
    figure()
    pdeplot (p ,[],t,'XYData',error,'ZData',error,'ColorBar','on')
    title("Error at T="+T+", hmax="+hmax)
  
    i=i+1;
end

% Plot Conv 
L2E
p = polyfit(log(hmax_list),log(L2E),1);
alpha = p(1)
figure ()
%xlabel ('hmax')
%ylabel('L2E')
loglog( hmax_list , L2E , 'DisplayName' , 'L2 norm of error')
hold on
loglog( hmax_list , hmax_list.^alpha , 'DisplayName' , 'hmax\^alpha')
hold off
legend show

end






%% Assembler functions based on book (The Finite Element Method:Theory, Implementation, and Applications %%%%%%%%%%%%%
 
% derivative f 
function df = ddf(x1, x2)
    df = 2 * pi * [-x2, x1];
end

% Convection Matrix Assembler
function C = ConvectionAssembler2D(p,t,bx,by)
    np=size(p,2);
    nt=size(t,2);
    C=sparse(np,np);
    for i=1:nt
        loc2glb=t(1:3,i);
        x=p(1,loc2glb);
        y=p(2,loc2glb);
        [area,b,c]=HatGradients(x,y);
        bxmid=mean(bx(loc2glb));
        bymid=mean(by(loc2glb));
        CK=ones(3,1)*(bxmid*b+bymid*c)'*area/3;
        C(loc2glb,loc2glb)=C(loc2glb,loc2glb)+CK;
    end
end

%Mass Matrix Assembler
function M = MassAssembler2D(p,t)
    np = size(p,2); % number of nodes
    nt = size(t,2); % number of elements
    M = sparse(np,np); % allocate mass matrix
    for K = 1:nt % loop over elements
        loc2glb = t(1:3,K); % local-to-global map
        x = p(1,loc2glb); % node x-coordinates
        y = p(2,loc2glb); % y
        area = polyarea(x,y); % triangle area
        MK = [2, 1, 1; 1, 2, 1; 1, 1, 2]/12*area; % element mass matrix
        M(loc2glb,loc2glb) = M(loc2glb,loc2glb)+ MK; % add element masses to M
    end
end

%Gradients 
function [area,b,c] = HatGradients(x,y)
area=polyarea(x,y);
b=[y(2)-y(3); y(3)-y(1); y(1)-y(2)]/2/area;
c=[x(3)-x(2); x(1)-x(3); x(2)-x(1)]/2/area;
end
