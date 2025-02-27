%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                               %%%
%%% Lab 1, part 3                 %%%
%%%                               %%%
%%% Scientific Computing for      %%%
%%% PDE                           %%%
%%%                               %%%
%%%                               %%%
%%% Author: Ken Mattsson          %%%
%%% Date:   2022-06-30            %%%
%%%                               %%%
%%% Solve u_t+(1/2u^2)_x=0        %%%
%%%                               %%%
%%% Use periodic operators        %%%
%%% Both implicit (spectral)      %%%
%%% and explicit of order         %%%
%%% 2,4,6,8,10 and 12             %%%
%%%                               %%%
%%% Possibility to add also       %%%
%%% Artificial Dissipation (AD)   %%%
%%%                               %%%
%%%                               %%%
%%% Use RK4 to time-integrate     %%%
%%% Test also  convergence        %%%
%%%                               %%%
%%% The code generates an avi-    %%%
%%% file for numerical solution   %%%
%%%                               %%%
%%% Here use a smooth             %%%
%%% initial data.                 %%%
%%%                               %%%
%%% We compare stability with     %%%
%%% and without addition of AD    %%%
%%%                               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 close all;
 clc;


disp(' ');   
disp('---------------------------------------------')
disp('Code that solve the inviscid Burgers''equation with periodic boundary condition.')
disp('Here using explicit stencils of orders 2,4,6,8,10,12 and an Implicit spectral accurate stencil')
disp('We compare the numerial solution with and without Artificial Dissipation')
%disp('We also compare against a novel type of AD refered to as the RV method.')

disp(' '); 
disp('The red line is the analytic solution and the blue the numerical solution. An animation of the numerical solution is generated and stored as a avi-file.')
%disp('The time-step is set to dt=1/80 and the end time of the simulation is t_1=4.')


disp(' '); 
filnamn = input('The name of the avi-file: ','s');
disp(' '); 


 AD=-1;
 while (AD ~=0 &&  AD ~=1)
 AD = input('With (1) or without (0) addition of Artificial Disiptation: ');
 end

 order=0;
 while (order ~=2 &&  order ~=4 && order ~=6 && order ~=8 && order ~=10 && order ~=12 && order ~=106 )
 order = input('Order of accuracy explicit (2) (4) (6) (8) (10) (12) or implicit spectral accurate (106) : ');
 end
 
 m=0;
 while ( m <=15 )
 m = input('How many grid-intervals (>15) : ');
 end
 

    scrsz = get(0,'ScreenSize');
    figure('Position',[scrsz(3)/2 scrsz(4) scrsz(3)/2 scrsz(4)])
    vidObj = VideoWriter(filnamn);
    open(vidObj);

    
x_l=0;x_r=1;    % The boundaries of the domain
domain=x_r-x_l;

%m=401;           % Number of grid-intervals, first grid
t_1=2;           % End time
t=0;

h=domain/m;      % Grid-step
k=h/25;

max_itter=floor(t_1/k); 

n_step=500;
theAxes=[x_l x_r 0 2]; % Regarding the figure


if order <100   % Explicit
    [H,Q,M] = Periodic_E_SC ( domain,m, order );
    [S] = Periodic_AD_SC ( domain,m, order );
else            % Implcit Spectral
    [H,Q,M] = Periodic_S6_SC ( domain,m);
    [S] = Periodic_AD_SC ( domain,m,order);
end

[L, U] = lu(H);   % 

if AD==1
    Q=Q-S;
else
    n_step=50;
    %max_itter=2000;
end


temp=zeros(m,1);    % Temporary vector in RK4

w1=zeros(m,1);      % Step 1 vector in RK4
w2=zeros(m,1);      % Step 2 vector in RK4
w3=zeros(m,1);      % Step 3 vector in RK4
w4=zeros(m,1);      % Step 4 vector in RK4

x=linspace(x_l,x_r-h,m);	  % Discrete x-values   

V=Initial_P1(t,x,0)+0.5;                  % Initial data

for nr_itter=1:max_itter

%%%--------Start R-K utan dissipation----------------------------------------
  w1=RHS_P2(L,U,Q,V);
  
  w2=RHS_P2(L,U,Q,V+k/2*w1);
   
  w3=RHS_P2(L,U,Q,V+k/2*w2);
 
  w4=RHS_P2(L,U,Q,V+k*w3);
    
  V=V+k/6*(w1+2*w2+2*w3+w4);
  
  t=t+k; 
  
  if mod(nr_itter,n_step)==0
      Plotta_1D_SC; % Plott the solution and generate a movie
  end
  
end
 
 close(vidObj);
 
 
    figure(2);
    plot(x,V,'b','LineWidth',1);
    xlabel('x');
    ylabel('u');
    title(['Numerical solution at t = ',num2str(t), ' Order = ', num2str(order)])
    %title(['Wave propagation',ordningstyp])
    axis(theAxes);
    ax = gca; % current axes
    ax.FontSize = 16;


    
