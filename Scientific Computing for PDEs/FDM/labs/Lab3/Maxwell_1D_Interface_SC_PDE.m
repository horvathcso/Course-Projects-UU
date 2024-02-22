%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                               %%%
%%% Lab 1, part 5                 %%%
%%%                               %%%
%%% Scientific Computing for      %%%
%%% PDE                           %%%
%%%                               %%%
%%%                               %%%
%%% Author: Ken Mattsson          %%%
%%% Date:   2022-06-30            %%%
%%%                               %%%
%%% Solve 1D Maxwell equations,   %%%
%%% coupling two different media  %%%
%%% (discontinuous parameters)    %%%
%%%                               %%%
%%% In most simple materials      %%%
%%% (except metals) mu=1, and     %%%
%%% epsilon >= 0, and             %%%
%%% discontinuous at the          %%%
%%% interface between materials   %%%
%%%                               %%%
%%% using SBP-Projection          %%%
%%% C*u_t+A*u_x=0,                %%%
%%%                               %%%
%%% A=[0 1  C=[epsilon 0   u=[u1  %%%
%%%    1 0]       0   mu]    u2]  %%%
%%%                               %%%
%%%                               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;


disp(' ');   
disp('---------------------------------------------')
disp('Code that solve Maxwells'' equations in 1D with non-periodic boundary conditions' )
disp('and with a jump in the media parameters at x=1')
disp('Here using explicit SBP operators of orders 2,3,4,5,6 and 7')
disp('The odd number are introduces upwind AD (and the even numbers are without any AD).')
%disp('We also compare against a novel type of AD refered to as the RV method.')

disp(' '); 
disp('The red line is the magnetic component and the blue the electric component. An animation of the numerical solution is generated and stored as a avi-file.')
disp('The time-step is set to dt=1/10 and the end time of the simulation is t_1=7. Initial data is a Gaussian ptofile centered at x=0')
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

  
      disp('We have two different media, meeting at x=1.  epsilon=1 in the left domain(x<1)') 
      disp(' '); 
      epsilon_r = input('Specify the value for parameter epsilon>0 in right domain (x>1): ');
      disp(' '); 
  
  m=0;
  while ( m <=15 )
      m = input('How many grid-points (>15) : ');
      disp(' '); 
  end


epsilon_l=1;
mu_l=1;

%epsilon_r=1;
mu_r=1;

n_l=sqrt(epsilon_l);
n_r=sqrt(epsilon_r);

% Computes the reflection and transmission coefficients
RC=( (n_l-n_r)/(n_l+n_r) )^2;
TC=( 2*n_l/(n_l+n_r) )^2;


% How often to update the movie
n_step=10;

scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)/2 scrsz(4) scrsz(3)/2 scrsz(4)])
clc;

vidObj = VideoWriter(filnamn);
open(vidObj);

C_L=[epsilon_l 0
     0         mu_l];

C_R=[epsilon_r 0
     0         mu_r];

A=[0 1
   1 0];

e1=[1 0];e2=[1 0]; % Pick out variable
I_2=eye(2);
I_4=eye(4);



CFL=0.1; %CFL=k/h
rr=0.1; %Width of Gaussian
x_0=0;

t_1=1.7;
xb_l=-2;xb_r=4;xb_i=1;
%xb_l=-1;xb_r=1;xb_i=0;
bredd=xb_r-xb_i;
yb_d=-2;yb_u= 1.1;

    h=bredd/(m-1);
    m2=2*m;
    n=4*m;
    
    Val_operator_SC_PDE;
    
    new=2;		  	        % tid (n+1)
    old=1;	        	    % tid (n)
    temp_tid=0;		        % tempor?r vid tidskiftningen
    
    t=0;
    
    dt=CFL*h;               % CFL
    
    max_itter=floor(t_1/dt);
    
    e_1=zeros(m,1);e_1(1)=1;
    e_m=zeros(m,1);e_m(m)=1;
    I_m=eye(m);
    BB_L=kron(inv(C_L),I_m);
    BB_R=kron(inv(C_R),I_m);

    BB=[BB_L 0*BB_L;
        BB_R*0 BB_R];
    
    if mod(ordning,2)==0    % Regular SBP
        DI=D1*0;
    else                    % Upwind SBP
        D1=(Dp+Dm)/2;
        DI=(Dp-Dm)/2;
    end
    DI=sparse(DI);
    D1=sparse(D1);
    HI=sparse(HI);
    
    % Indices for the 2 different blocks.
    d_1=1:m2;
    d_2=m2+1:n;

    I_m=eye(m);
    HI4=kron(I_4,HI);
    I_m4=kron(I_4,I_m);

    BC=1; % Type of outher BC

    BC_I=[kron(I_2,e_m'), - kron(I_2,e_1')];
    BC_0=0*kron(e1,e_1');

    if BC == 1
        L=[kron(e1,e_1') BC_0;
           BC_0 kron(e1,e_m');
           BC_I];
    elseif BC == 2
        L=[kron(e2,e_1') BC_0;
           BC_0 kron(e2,e_m');
           BC_I];
    elseif BC == 3
        L=[kron(e1+a_l*e2,e_1') BC_0;
           BC_0 kron(e1+a_r*e2,e_m'); 
           BC_I];
    end

   
    P=I_m4-HI4*L'*inv(L*HI4*L')*L;

    D=P*BB*(kron(I_2,kron(A,D1))+kron(I_2,kron(I_2,DI)));


temp=zeros(n,1);  % temporary solutionvector in RK4 w1,..,w4 Left domain

w1=zeros(n,1);      % First step  in RK, Left domain
w2=zeros(n,1);      % Second step in RK, Left domain
w3=zeros(n,1);      % Third step  in RK, Left domain
w4=zeros(n,1);      % Fourt step  in RK, Left domain

x_l=linspace(xb_l,xb_i,m);	  % x points Left domain
x_r=linspace(xb_i,xb_r,m);	  % x points Right domain


uc1_l=exp(-((x_l+x_0-t)/rr).^2)';
uc2_l=-exp(-((x_l+x_0+t)/rr).^2)';

uc1_r=exp(-((x_r+x_0-t)/rr).^2)';
uc2_r=-exp(-((x_r+x_0+t)/rr).^2)';


V=zeros(n,2);	                % Solution vector left domain

V(1:m,old)=uc2_l-uc1_l;
V(m+1:m2,old)=uc2_l+uc1_l;

V(m2+1:m2+m,old)=uc2_r-uc1_r;
V(m2+m+1:n,old)=uc2_r+uc1_r;

Plotta_Maxwell_1D_Interface_SC; % Plott the solution and generate a movie

%max_itter=1;

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
      Plotta_Maxwell_1D_Interface_SC; % Plott the solution and generate a movie
  end

  % Analytic slolution after t=2

  %Domain width = 2

end

  %differens(i)=felet(max_itter);
  %differens(i)=felet(max_itter+1);
   RF=max(V(1:m,old));
   TF=-min(V(m2+1:m2+m,old));
%   
%   
   error=abs(sqrt(RC)-RF);
   disp(['Error in transmission coefficient : ', num2str(error)])
%   differens(i)=abs(sqrt(TC)-TF);
% %   RF=max(V_l(1:m,old));
% %   TF=-min(V_r(1:m,old));
% 
% 
% 
% sqrt(RC)
% sqrt(TC)

 close(vidObj);
 %tiden=linspace(0,t_1,max_itter+1);
 
 
 
figure(2);
plot(x_l,V(1:m,old),'r',x_l,V(m+1:m2,old),'b',x_r,V(m2+1:m2+m,old),'r--',x_r,V(m2+m+1:n,old),'b--','LineWidth',1);
%plot(x_r,V_r(1:m,old),'r--',x_r,V_r(m+1:n,old),'b--','LineWidth',1);hold;
title(['Numerical solution at t = ',num2str(t_1)]);
axis([xb_l xb_r -1.3 1.1]);
grid;xlabel('x');
legend('Electric (E)','Magnetic (H)')
ax = gca;          % current axes
ax.FontSize = 16;

% figure(3);
% plot(x_l,exakt_l(1:m),'r',x_l,exakt_l(m+1:n),'b',x_r,exakt_r(1:m),'r--',x_r,exakt_r(m+1:n,old),'b--','LineWidth',1);
% %plot(x_r,V_r(1:m,old),'r--',x_r,V_r(m+1:n,old),'b--','LineWidth',1);hold;
% title(['Numerical solution at t = ',num2str(t_1)]);
% axis([xb_l xb_r -1.1 1.1]);
% grid;xlabel('x');
% legend('v^{(1)}','v^{(2)}')
% ax = gca;          % current axes
% ax.FontSize = 16;

% RF=max(V_l(1:m,old));
% TF=-min(V_r(1:m,old));
% 
% 
% 
% sqrt(RC)
% sqrt(TC)


