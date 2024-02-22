%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                               %%%
%%% Lab 1, part 2                 %%%
%%%                               %%%
%%% Scientific Computing for      %%%
%%% PDE                           %%%
%%%                               %%%
%%%                               %%%
%%% Author: Ken Mattsson          %%%
%%% Date:   2022-06-30            %%%
%%%                               %%%
%%% Solve u_t+u_x=0               %%%
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
%%% Here use a non-smooth         %%%
%%% initial data                  %%%
%%% as initial data               %%%
%%%                               %%%
%%% We compare numerical  error   %%%
%%% for explicit and implicit     %%%
%%% finite difference stencils    %%%
%%% In particular we compare the  %%%
%%% solution with and withoud     %%%
%%% the addition of AD            %%%
%%%                               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 close all;
 clc;


disp(' ');   
disp('---------------------------------------------')
disp('Code that solve the first order wave equation in 1-D with periodic boundary condition.')
disp('Here using explicit stencils of orders 2,4,6,8,10,12 and an Implicit spectral accurate stencil')
disp('We here test for non-smooth initial data to compare the numerical errors.')
disp('In particular we compare the numerial solution with and without Artificial Dissipation')

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
t_1=10;           % End time
t=0;

h=domain/m;      % Grid-step
k=h/25;

max_itter=floor(t_1/k); % How often to update the movie

n_step=250;
theAxes=[x_l x_r -0.3 1.3]; % Regarding the figure


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
end


temp=zeros(m,1);    % Temporary vector in RK4

w1=zeros(m,1);      % Step 1 vector in RK4
w2=zeros(m,1);      % Step 2 vector in RK4
w3=zeros(m,1);      % Step 3 vector in RK4
w4=zeros(m,1);      % Step 4 vector in RK4

x=linspace(x_l,x_r-h,m);	  % Discrete x-values   

felet=zeros(max_itter+1,1);	      % Error vector in time


exact=Initial_P2(t,x,0);    %Exact solution smooth

V=exact;                          % Numerical solution
felet(1)=sqrt(h)*norm(V-exact);

tt=rem(t,domain);

for nr_itter=1:max_itter

%%%--------Start R-K utan dissipation----------------------------------------
  w1=RHS_P(L,U,Q,V);
  
  w2=RHS_P(L,U,Q,V+k/2*w1);
   
  w3=RHS_P(L,U,Q,V+k/2*w2);
 
  w4=RHS_P(L,U,Q,V+k*w3);
    
  V=V+k/6*(w1+2*w2+2*w3+w4);
  
  t=t+k; 
  tt=rem(t,domain);
   
  exact=Initial_P2(tt,x,domain)+Initial_P2(tt,x,0)+Initial_P2(tt,x,-domain);
  
  felet(nr_itter+1)=sqrt(h)*norm(V-exact);
  
  if mod(nr_itter,n_step)==0
      Plotta_1D_SC; % Plott the solution and generate a movie
  end
  
end

  %felet(nr_itter+1);

  disp(['The l_2-error is: ', num2str(felet(nr_itter+1))])
 
 tiden=linspace(0,t_1,max_itter+1);
 close(vidObj);
 
 
    figure(2);
    plot(x,exact,'r',x,V,'b--','LineWidth',1);
    xlabel('x');
    ylabel('u');
    title(['Numerical and exact non-smooth solution at t = ',num2str(t), ' Order = ', num2str(order)])
    legend('Exact solution','Numerical solution')
    %title(['Wave propagation',ordningstyp])
    axis(theAxes);
    ax = gca; % current axes
    ax.FontSize = 16;


    
