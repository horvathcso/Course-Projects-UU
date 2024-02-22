%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                   %%%
%%% Lab 1, part 6                                     %%%
%%%                                                   %%%
%%% Scientific Computing for PDE                      %%%
%%%                                                   %%%
%%%                                                   %%%
%%%                                                   %%%
%%% Author: Ken Mattsson                              %%%
%%% Date:   2022-06-30                                %%%
%%%                                                   %%%
%%% Solve 2D Maxwell equations.                       %%%
%%%                                                   %%%
%%% C*u_t=A*u_x+B*u_y,                                %%%
%%%                                                   %%%
%%% A = -[0 0 0   B = [0 1 0   C = [ epsilon 0   0    %%%
%%%       0 0 1]       1 0 0          0      mu  0    %%%
%%%       0 1 0]       0 0 0]         0  0  epsilon]  %%%
%%%                                                   %%%
%%% Here one 4 blocks, with a jump in parameters,     %%%
%%% modeling wave propagation across two different    %%%
%%% medium                                            %%%
%%%                                                   %%%
%%% 4 domain problem discontinous media               %%%
%%%                                                   %%%
%%%  ----------------------------                     %%%
%%%  |             |            |                     %%%
%%%  |             |            |                     %%%
%%%  |     C_1     |    C_1     |                     %%%
%%%  |             |            |                     %%%
%%%  |             |            |                     %%%
%%%  ----------------------------                     %%%
%%%  |             |            |                     %%%
%%%  |             |            |                     %%%
%%%  |    C_1      |    C_2     |                     %%%
%%%  |             |            |                     %%%
%%%  |             |            |                     %%%
%%%  ----------------------------                     %%%
%%%                                                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

disp(' ');
disp('---------------------------------------------')
disp('Code that solve Maxwells'' equations in 2D on 4 block domain' )
disp('and with a jump in the media parameters in one of the blocks')
disp('Here using explicit SBP operators of orders 2,3,4,5,6 and 7')
disp('The odd number are introduces upwind AD (and the even numbers are without any AD).')
%disp('We also compare against a novel type of AD refered to as the RV method.')

disp(' ');
disp('Initial data is a Gaussian for the magnetic component centered at (-0.5, 0.5).')
disp('An animation of the magnetic field is generated and stored as an avi-file.')
disp('The time-step is set to dt=1/10 and the end time of the simulation is t_1=4.')
%
%
disp(' ');
filnamn = input('The name of the avi-file: ','s');
disp(' ');
%
%
%  AD=-1;
%  while (AD ~=0 &&  AD ~=1)
%  AD = input('With (1) or without (0) addition of Artificial Disiptation: ');
%  end
%
ordning=0;
while (ordning ~=2 &&  ordning ~=3 && ordning ~=4 && ordning ~=5 && ordning ~=6 && ordning ~=7)
    ordning = input('Order of accuracy of SBP operator (2) (3) (4) (5) (6) (7): ');
    disp(' ');
end

%ordning=9;

disp('We have two different media. epsilon_1=1 in media 1')
epsilon_2 = input('Specify the value for parameter epsilon_2>0 in medium 2: ');
disp(' ');

m=0;
while ( m <=15 )
    disp(' ');
    m = input('How many grid-points m (in each dimension and block): ');
    disp(' ');
end

BC=0;
  while (BC ~=1 &&  BC ~=2 &&  BC ~=3)
      disp(' ');
      disp('3 different types of boundary conditions:')
      disp('-------------------------------------------------------------------------');
      disp('(1) Specify only electric component (E)')
      disp('(2) Specify only magnetic component (H)')
      disp('(3) Specify non-reflecting BC')
      disp('-------------------------------------------------------------------------');
      disp(' ');
  BC = input('Type of boundry condition (1) (2) (3): ');
  disp(' ');
  end


scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)/2 scrsz(4) scrsz(3)/2 scrsz(4)])
clc;

vidObj = VideoWriter('Maxwell_2D_2020.avi');
open(vidObj);
epsilon_1=1;mu_1=1;
mu_2=1;

c1=1/sqrt(epsilon_1*mu_1); % Speed of light medium 1
c2=1/sqrt(epsilon_2*mu_2); % Speed of light medium 2

% How often to update the movie
n_step=ceil(20*max(c2,c1));



C_1=[epsilon_1   0      0
    0          mu_1    0
    0           0    epsilon_1];

C_2=[epsilon_2   0      0
    0          mu_2    0
    0           0    epsilon_2];

A=-[0 0 0
    0 0 1
    0 1 0];

B= [0 1 0
    1 0 0
    0 0 0];

C_1=sparse(C_1);
C_2=sparse(C_2);
A=sparse(A);
B=sparse(B);

I3=speye(3);
I4=speye(4);

e1=sparse([1 0 0]);e2=sparse([0 1 0]); e3=sparse([0 0 1]); % Pick out variable


CFL=0.1/max(c2,c1); %CFL=k/h
rr=0.1; %Width of Gaussian
%X_0=-1;Y_0=1; % Center of the initial  Gaussian

X_0=-0.5;Y_0=0.5; % Center of the initial  Gaussian

t_1=20;
x_l=-2;x_r=2;x_i=0;bredd=x_r-x_i;
y_d=-2;y_u=2;y_i=0;

theAxes_1=[x_l x_i y_d y_u -1 1];
theAxes_2=[x_i x_r y_d y_u -1 1];

theAxes=[x_l x_r y_d y_u -1 1];

h=bredd/(m-1);

Val_operator_SC_PDE;

if mod(ordning,2)==0    % Regular SBP
    DI=D1*0;
else                    % Upwind SBP
    D1=(Dp+Dm)/2;
    DI=(Dp-Dm)/2;
end
DI=sparse(DI);
D1=sparse(D1);
HI=sparse(HI);

m3=3*m;
m2=m*m;
m23=3*m2;  % Number of unknowns in each block
n=4*m23;   % Total number of unknowns

% Indices for the 4 different blocks.
d_1=0*m23+1:1*m23;
d_2=1*m23+1:2*m23;
d_3=2*m23+1:3*m23;
d_4=3*m23+1:4*m23;

% To pick out all but left point
Il=zeros(m-1,m);
for j=1:m-1
    Il(j,j+1)=1;
end
Il=sparse(Il);



% To pick out all but right point
Ir=zeros(m-1,m);
for j=1:m-1
    Ir(j,j)=1;
end
Ir=sparse(Ir);


new=2;		  	        % tid (n+1)
old=1;	        	    % tid (n)
temp_tid=0;		        % tempor?r vid tidskiftningen

t=0;

dt=CFL*h;               % CFL

max_itter=floor(t_1/dt);

e_1=zeros(m,1);e_1(1)=1;e_1=sparse(e_1);
e_m=zeros(m,1);e_m(m)=1;e_m=sparse(e_m);
I_m=speye(m);
D_x=kron(D1,I_m);HI_x=kron(HI,I_m);DI_x=kron(DI,I_m);
e_L=kron(e_1,I_m);e_R=kron(e_m,I_m);
D_y=kron(I_m,D1);HI_y=kron(I_m,HI);DI_y=kron(I_m,DI);
e_D=kron(I_m,e_1);e_U=kron(I_m,e_m);


% Pick out all but one point
e_Ll=kron(e_1,Il');e_Rl=kron(e_m,Il');
e_Lr=kron(e_1,Ir');e_Rr=kron(e_m,Ir');

e_Dl=kron(Il',e_1);e_Ul=kron(Il',e_m);
e_Dr=kron(Ir',e_1);e_Ur=kron(Ir',e_m);

% to avoid corner problem at outher boundaries
B_L=kron(e_1,Il');
B_R=kron(e_m,Ir');
B_U=kron(Il',e_m);
B_D=kron(Ir',e_1);


L0=sparse(0*kron(e3,e_L'));
I0=sparse(kron(zeros(2,3),e_L'));
II0=sparse(kron(zeros(2,3),e_Ll'));
I23=[e2;e3];I12=[e1;e2];



% Pick out the shared point in each of the 4 blocks
B1_I=kron(e_m',e_1');
B2_I=kron(e_1',e_1');
B3_I=kron(e_m',e_m');
B4_I=kron(e_1',e_m');


% To make sure the shared point between 4 blocks are consistent
IP=[     kron(I3,B1_I), -1/3*kron(I3,B2_I),  -1/3*kron(I3,B3_I),-1/3*kron(I3,B4_I);
    -1/3*kron(I3,B1_I),      kron(I3,B2_I),  -1/3*kron(I3,B3_I),-1/3*kron(I3,B4_I);
    -1/3*kron(I3,B1_I), -1/3*kron(I3,B2_I),       kron(I3,B3_I),-1/3*kron(I3,B4_I)];

Interface=[kron([e2;e3],e_Rl')    ,-kron([e2;e3],e_Ll')   ,                II0,             II0         ;
    II0                ,             II0       ,  kron([e2;e3],e_Rr')  , -kron([e2;e3],e_Lr');
    kron([e1;e2],e_Dr'),             II0       , -kron([e1;e2],e_Ur')  ,         II0         ;
    II0                , kron([e1;e2],e_Dl')   , II0                   , -kron([e1;e2],e_Ul');
    IP];

if BC == 1

    % If electric field as BC
    Boundary=[kron(e3,e_L'),      L0        ,      L0        ,       L0              ;
        L0        , kron(e3,e_R')  ,      L0        ,       L0              ;
        L0        ,      L0        , kron(e3,e_L')  ,       L0              ;
        L0        ,      L0        ,      L0        ,       kron(e3,e_R')   ;
        kron(e1,e_U'),      L0        ,      L0        ,       L0              ;
        L0        , kron(e1,e_U')  ,      L0        ,       L0              ;
        L0        ,      L0        , kron(e1,e_D')  ,       L0              ;
        L0        ,      L0        ,      L0        ,  kron(e1,e_D' )]      ;


elseif BC==2

    % If magnetic field as BC, requires special attention at corners
    % and where interface meets boundary
    L0=sparse(0*kron(e2,B_L'));

    Boundary=[kron(e2,B_L') ,     L0        ,      L0       ,       L0       ;
        L0        , kron(e2,B_R') ,      L0       ,       L0       ;
        L0        ,     L0        , kron(e2,B_L') ,       L0       ;
        L0        ,     L0        ,      L0       ,  kron(e2,B_R') ;
        kron(e2,B_U') ,     L0        ,      L0       ,       L0       ;
        L0        , kron(e2,B_U') ,      L0       ,       L0       ;
        L0        ,     L0        , kron(e2,B_D') ,       L0       ;
        L0        ,     L0        ,      L0       ,  kron(e2,B_D' )];
else %BC=3, meaing non-reflecting BC

    Boundary=[kron(e2+c1*e3,e_L'),      L0        ,      L0        ,       L0              ;
        L0        , kron(e2-c1*e3,e_R')  ,      L0        ,       L0              ;
        L0        ,      L0        , kron(e2+c1*e3,e_L')  ,       L0              ;
        L0        ,      L0        ,      L0        ,       kron(e2-c2*e3,e_R')   ;
        kron(e1+c1*e2,e_U'),      L0        ,      L0        ,       L0              ;
        L0        , kron(e1+c1*e2,e_U')  ,      L0        ,       L0              ;
        L0        ,      L0        , kron(e1-c1*e2,e_D')  ,       L0              ;
        L0        ,      L0        ,      L0        ,  kron(e1-c2*e2,e_D' )]      ;
end

L=[Boundary;
    Interface];

%L=[Lx;Ly];



H3=sparse(kron(I3,kron(H,H)));
HI3=sparse(kron(I3,kron(HI,HI)));
HI34=kron(I4,HI3);

P=speye(n)-HI34*L'*inv(L*HI34*L')*L; % Global Projection operator

t1=kron(inv(C_1),kron(I_m,I_m));
t2=kron(inv(C_2),kron(I_m,I_m));
t0=0*t1;
BB=[t1 t0 t0 t0;
    t0 t1 t0 t0;
    t0 t0 t1 t0;
    t0 t0 t0 t2];


D=P*BB*(kron(I4,kron(A,D_x))+kron(I4,kron(I3,DI_x)))*P+...
    P*BB*(kron(I4,kron(B,D_y))+kron(I4,kron(I3,DI_y)))*P;

temp=zeros(n,1);    % temporary solutionvector in RK4 w1,..,w4
w1=zeros(n,1);      % First step in RK
w2=zeros(n,1);      % Second step in RK
w3=zeros(n,1);      % Third step in RK
w4=zeros(n,1);      % Fourt step in RK

xx_1=linspace(x_l,x_i,m);	  % x points
xx_2=linspace(x_i,x_r,m);	  % x points
yy_1=linspace(y_d,y_i,m);
yy_2=linspace(y_i,y_u,m);

[X_1,Y_1]=meshgrid(xx_1,yy_2);
[X_2,Y_2]=meshgrid(xx_2,yy_2);
[X_3,Y_3]=meshgrid(xx_1,yy_1);
[X_4,Y_4]=meshgrid(xx_2,yy_1);


UC2_1=exp(-((X_1-X_0)/rr).^2-((Y_1-Y_0)/rr).^2);
UC1_1=0*UC2_1;
UC3_1=0*UC2_1;

UC2_2=exp(-((X_2-X_0)/rr).^2-((Y_2-Y_0)/rr).^2);
UC1_2=0*UC2_2;
UC3_2=0*UC2_2;

UC2_3=exp(-((X_3-X_0)/rr).^2-((Y_3-Y_0)/rr).^2);
UC1_3=0*UC2_3;
UC3_3=0*UC2_3;

UC2_4=exp(-((X_4-X_0)/rr).^2-((Y_4-Y_0)/rr).^2);
UC1_4=0*UC2_4;
UC3_4=0*UC2_4;

V_1=zeros(m23,1);
V_2=zeros(m23,1);
V_3=zeros(m23,1);
V_4=zeros(m23,1);

V=zeros(n,2); % Numerical solution

i1=1:m2;
i2=m2+1:2*m2;
i3=2*m2+1:m23;
V_1(i1)=reshape(UC1_1,m2,1);
V_1(i2)=reshape(UC2_1,m2,1);
V_1(i3)=reshape(UC3_1,m2,1);

V_2(i1)=reshape(UC1_2,m2,1);
V_2(i2)=reshape(UC2_2,m2,1);
V_2(i3)=reshape(UC3_2,m2,1);

V_3(i1)=reshape(UC1_3,m2,1);
V_3(i2)=reshape(UC2_3,m2,1);
V_3(i3)=reshape(UC3_3,m2,1);

V_4(i1)=reshape(UC1_4,m2,1);
V_4(i2)=reshape(UC2_4,m2,1);
V_4(i3)=reshape(UC3_4,m2,1);

V(:,old)=[V_1;V_2;V_3;V_4];

Divergence_1=D1*UC3_1+(D1*UC1_1')';
Divergence_2=D1*UC3_2+(D1*UC1_2')';
Divergence_3=D1*UC3_3+(D1*UC1_3')';
Divergence_4=D1*UC3_4+(D1*UC1_4')';


Plotta_Maxwell_2D_Interface_4B; % Plott the solution and generate a movie

j=1;
nr_div=floor(max_itter/n_step);
div_fel=zeros(nr_div,1);
div_tid=zeros(nr_div,1);

for nr_itter=1:max_itter

    %%%--------Start R-K utan dissipation----------------------------------------

    w1=D*V(:,old);

    temp=V(:,old)+dt/2*w1;

    w2=D*temp;

    temp=V(:,old)+dt/2*w2;

    w3=D*temp;

    temp=V(:,old)+dt*w3;

    w4=D*temp;

    V(:,new)=V(:,old)+dt/6*(w1+2*w2+2*w3+w4);

    t=t+dt;

    temp_tid=old;old=new;new=temp_tid;

    if mod(nr_itter,n_step)==0
        j=j+1;

        V_1=V(d_1,old);
        V_2=V(d_2,old);
        V_3=V(d_3,old);
        V_4=V(d_4,old);

        UC1_1=reshape(V_1(i1),m,m);
        UC2_1=reshape(V_1(i2),m,m);
        UC3_1=reshape(V_1(i3),m,m);

        UC1_2=reshape(V_2(i1),m,m);
        UC2_2=reshape(V_2(i2),m,m);
        UC3_2=reshape(V_2(i3),m,m);

        UC1_3=reshape(V_3(i1),m,m);
        UC2_3=reshape(V_3(i2),m,m);
        UC3_3=reshape(V_3(i3),m,m);

        UC1_4=reshape(V_4(i1),m,m);
        UC2_4=reshape(V_4(i2),m,m);
        UC3_4=reshape(V_4(i3),m,m);

        Divergence_1=D1*UC3_1+(D1*UC1_1')';
        Divergence_2=D1*UC3_2+(D1*UC1_2')';
        Divergence_3=D1*UC3_3+(D1*UC1_3')';
        Divergence_4=D1*UC3_4+(D1*UC1_4')';

        div_fel(j)=norm(Divergence_1)/m+norm(Divergence_2)/m+norm(Divergence_3)/m+norm(Divergence_4)/m;
        div_tid(j)=t;

        Plotta_Maxwell_2D_Interface_4B; % Plott the solution and generate a movie
    end

end



close(vidObj);
tiden=linspace(0,t_1,max_itter+1);



V_1=V(d_1,old);
V_2=V(d_2,old);
V_3=V(d_3,old);
V_4=V(d_4,old);

UC1_1=reshape(V_1(i1),m,m);
UC2_1=reshape(V_1(i2),m,m);
UC3_1=reshape(V_1(i3),m,m);

UC1_2=reshape(V_2(i1),m,m);
UC2_2=reshape(V_2(i2),m,m);
UC3_2=reshape(V_2(i3),m,m);

UC1_3=reshape(V_3(i1),m,m);
UC2_3=reshape(V_3(i2),m,m);
UC3_3=reshape(V_3(i3),m,m);

UC1_4=reshape(V_4(i1),m,m);
UC2_4=reshape(V_4(i2),m,m);
UC3_4=reshape(V_4(i3),m,m);

Divergence_1=D1*UC3_1+(D1*UC1_1')';
Divergence_2=D1*UC3_2+(D1*UC1_2')';
Divergence_3=D1*UC3_3+(D1*UC1_3')';
Divergence_4=D1*UC3_4+(D1*UC1_4')';


figure(2);

surf(X_1,Y_1,UC3_1,'FaceLighting', 'gouraud');hold
surf(X_2,Y_2,UC3_2,'FaceLighting', 'gouraud');
surf(X_3,Y_3,UC3_3,'FaceLighting', 'gouraud');
surf(X_4,Y_3,UC3_4,'FaceLighting', 'gouraud');hold;
title(['Numerical solution at t = ',num2str(t)]);
xlabel('x');
ylabel('y');
colormap(jet(256))
shading interp
material dull
lighting phong
view(-70,20)
axis equal;
axis(theAxes);
camlight left;
%text(-1,-1,'Block 3','FontSize',16)
%text(1,-1,'Block 4','FontSize',16)
ax = gca;          % current axes
ax.FontSize = 16;

figure(3);

surf(X_1,Y_1,Divergence_1,'FaceLighting', 'gouraud');hold;
surf(X_2,Y_2,Divergence_2,'FaceLighting', 'gouraud');
surf(X_3,Y_3,Divergence_3,'FaceLighting', 'gouraud');
surf(X_4,Y_4,Divergence_4,'FaceLighting', 'gouraud');hold;
title(['Divergence at t = ',num2str(t)]);
xlabel('x');
ylabel('y');
colormap(jet(256))
shading interp
material dull
lighting phong
view(-70,20)
axis equal;
axis(theAxes);
camlight left;
ax = gca;          % current axes
ax.FontSize = 16;

figure(4);
plot(div_tid,div_fel,'LineWidth',1);
title(['L_2-error of divergence until t = ',num2str(t)]);
xlabel('t')
ylabel('||Div||')
ax = gca;          % current axes
ax.FontSize = 16;
%div_fel=norm(Divergence)/m;



disp(['Error in divergence : ',num2str(div_fel(end))])

