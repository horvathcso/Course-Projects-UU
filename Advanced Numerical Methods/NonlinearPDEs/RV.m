%% Given parameters
T=1;
CFL=0.1;
TOL=10^(-3);
C_vel=0.5;
C_RV=4;

%Used geometry
g=Rectangle(-2,-2.5,2,1.5);



%% Problem 1 - numerical fem solutions and error + convergence rate calculation
%hmax values to run the simulation for
hmax_list = [1/8, 1/16];

%Iteration on possible hmax values
for hmax = hmax_list
         %mesh data
    [p ,e , t ] = initmesh (g , 'hmax' , hmax); %function call to create mesh
    x=p(1,:)'; % vector of x1 coordinates 
    y=p(2,:)'; % vector of x2 coordinates
    
    % Set mass matrix
    M = MassAssembler2D(p,t);

    %Initial setup    
    U_0=initial_data(x,y)';
    U_n=U_0;
    U_i=U_0;
    U_new=U_0;
    U_old=U_0;
    
    nt = size(t,2); hk=[]
    for K = 1:nt % for each element
        loc2glb = t(1:3,K); % local-to-global map
        x = p(1,loc2glb); % node x-coordinates
        y = p(2,loc2glb); % node y-coordinates
        hk(K)=min([norm([x(1)-x(2),y(1)-y(2)]),norm([x(2)-x(3),y(2)-y(3)]),norm([x(3)-x(1),y(3)-y(1)]), 2*norm([x(1)-sum(x)/3,y(1)-sum(y)/3])]); % diameter
    end

    %Time integration Crank-Nicholson
    time = 0;
    kn = CFL * hmax; % timstep - not depends on U_n due to f'

    while time<T
        df_n=ddf(U_n);
        C_n=ConvectionAssembler2D(p,t,df_n(:,1),df_n(:,2));
        R_n = ResidualAssembler(p,t, ddf(U_n), hk, U_n, U_old, M, C_n, kn,C_vel,C_RV);
        %Set up equatddion matrix / vector
        b=((M/kn) - (C_n/2) - (R_n/2)) * U_n;
        
       r=1;
        while r>TOL
        df_n=ddf(U_i);
        C_i=ConvectionAssembler2D(p,t,df_n(:,1),df_n(:,2));

        A=((M/kn) + (C_i/2) + (R_n/2));
        

        %Boundary conditions
        I = eye( length ( p ));
        A(e(1,:) ,:) =I(e(1,:) ,:);
        b(e(1,:)) = pi/4;


        %Solve equation
            U_new=A\b;
            r=norm(U_i-U_new,2);
            disp(['The value of r is: ', num2str(r)])
            U_i=U_new;
        end
        time=time+kn;
        disp(['The value of time is: ', num2str(time)])
        U_old=U_n;
        U_n=U_new;
    end

    
   %Plot solution
    figure()    
    pdeplot(p,e,t,"XYData",U_n,'Zdata',U_n);
    title("Solution at T="+T+", hmax="+hmax)

    %Error
    error=U_n-U_0;
    figure()
    pdeplot (p ,[],t,'XYData',error,'ZData',error,'ColorBar','on')
    title("Error at T="+T+", hmax="+hmax)


end






%% Assembler functions based on book (The Finite Element Method:Theory, Implementation, and Applications %%%%%%%%%%%%%


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

% SC matrix assembly
function R = ResidualAssembler(p,t, df,hk, U, U_old, M, C, kn, C_vel,C_RV)
np = size(p,2);
nt = size(t,2);
R = sparse(np,np); % allocate matrix
RU=M\(1/kn*M*(U-U_old)+C*U);
for K = 1:nt % for each element
loc2glb = t(1:3,K); % local-to-global map
x = p(1,loc2glb); % node x-coordinates
y = p(2,loc2glb); % node y-coordinates
[area,b,c] = HatGradients(x,y);
dx=df(loc2glb,1);
dy=df(loc2glb,2);
h_k=hk(K);
b_k=max([norm([dx(1),dy(1)]),norm([dx(2),dy(2)]),norm([dx(3),dy(3)])]);
U_norm=max(abs(U-mean(U)));
Rk=max(abs(RU(loc2glb)));

e=min([C_vel*h_k*b_k,C_RV*h_k^2*Rk/U_norm]);
AK = e*(b*b'+c*c')*area; % element stiffness matrix
R(loc2glb,loc2glb) = R(loc2glb,loc2glb)+ AK; % add element stiffnesses to A
end
end

%Gradients 
function [area,b,c] = HatGradients(x,y)
area=polyarea(x,y);
b=[y(2)-y(3); y(3)-y(1); y(1)-y(2)]/2/area;
c=[x(3)-x(2); x(1)-x(3); x(2)-x(1)]/2/area;
end

% derivative f 
function df=ddf(u)
    df =[cos(u),-sin(u)];
end

%initial
function init=initial_data(x,y)
    init=[];
    for i=1:length(x)
        if sqrt(x(i).^2 +y(i).^2)<=1
            init(i)=14*pi/4;
        else
            init(i)=pi/4;
        end
    end
end
function r = Rectangle(xmin,ymin,xmax,ymax)
r=[2 xmin xmax ymin ymin 1 0;
2 xmax xmax ymin ymax 1 0;
2 xmax xmin ymax ymax 1 0;
2 xmin xmin ymax ymin 1 0]';
end