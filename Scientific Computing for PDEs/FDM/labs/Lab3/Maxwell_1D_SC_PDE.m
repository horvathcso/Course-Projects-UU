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
%%%                               %%%
%%%                               %%%
%%% using SBP-Projection          %%%
%%% C*u_t+D*u_x=0,                %%%
%%%                               %%%
%%% A = [0 1   C = [c1 0   u=[u1  %%%
%%%      1 0]       0 c2]     u2] %%%
%%%                               %%%
%%% Try different BC. Both        %%%
%%% Well-posed, and ill-posed     %%%
%%%                               %%%
%%% (1) u1=0, u1=0 (left, right)  %%%
%%%                               %%%
%%% (2) u2=0, u2=0 (left, right)  %%%
%%%                               %%%
%%% (3) u1+beta*u2=0,            %%%
%%%     u1-beta*u2=0             %%%
%%%    Test different beta       %%%
%%%                               %%%
%%%                               %%%
%%% (4) u1=0, u1=0 (left, right)  %%%
%%%     u2=0, u2=0 (left, right)  %%%
%%%                               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;


disp(' ');   
disp('---------------------------------------------')
disp('Code that solve Maxwells'' equations in 1D with non-periodic boundary conditions' )
disp('Here using explicit SBP operators of orders 2,3,4,5,6 and 7')
disp('The odd number are introduces upwind AD (and the even numbers are without any AD).')
%disp('We also compare against a novel type of AD refered to as the RV method.')

% disp(' '); 
% disp('The red line is the analytic solution and the blue the numerical solution. An animation of the numerical solution is generated and stored as a avi-file.')
% %disp('The time-step is set to dt=1/80 and the end time of the simulation is t_1=4.')
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
  end

  BC=0;
  while (BC ~=1 &&  BC ~=2 && BC ~=3 && BC ~=4)
      disp(' ');
      disp('4 different types of boundary conditions:')
      disp('-------------------------------------------------------------------------');
      disp('(1) Specify only electric component (E)')
      disp('(2) Specify only magnetic component (H)')
      disp('(3) Specify a linear combination (E+\beta*H, E-\beta*H) at the left and right boundary, repectively') 
      disp('(4) Specify both electric and magnetic component at each boundary')
      disp('-------------------------------------------------------------------------');
      disp(' ');
  BC = input('Type of boundry condition (1) (2) (3) (4): ');
  end

  if BC==3
      disp('Specify a linear combination (E+\beta*H, E-\beta*H) at the left and right boundary, repectively') 
      beta = input('Specify the value for \beta ');
  end
  
  m=0;
  while ( m <=15 )
      m = input('How many grid-points (>15) : ');
  end
% 




% Accuracy of the SBP
%ordning=9;

% How often to update the movie
n_step=10;

scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)/2 scrsz(4) scrsz(3)/2 scrsz(4)])
clc;

vidObj = VideoWriter(filnamn);
open(vidObj);

C=[1 0
   0 1];

A=[0 1
   1 0];

%alpha=-1; % alpha<=0 for well-posed


e1=[1 0];e2=[0 1]; % Pick out variable
I_2=eye(2);

CFL=0.1; %CFL=k/h
rr=0.1; %Width of Gaussian

t_1=1.8;
x_l=-1;x_r=1;bredd=x_r-x_l;
y_d=-2.1;y_u= 2.1;


    h=bredd/(m-1);
    n=2*m;
    
    Val_operator_SC_PDE;  % Change here to make use of upwind SBP
    
    new=2;		  	        % tid (n+1)
    old=1;	        	    % tid (n)
    temp_tid=0;		        % tempor?r vid tidskiftningen
    
    t=0;
    
    dt=CFL*h;               % CFL
    
    max_itter=floor(t_1/dt);
    
    e_1=zeros(m,1);e_1(1)=1;
    e_m=zeros(m,1);e_m(m)=1;
    
    I_m=eye(m);
    HI2=kron(I_2,HI);
    I_m2=kron(I_2,I_m);

    %BC=4;

    if BC == 1
        L=[kron(e1,e_1');
           kron(e1,e_m')];
    elseif BC == 2
        L=[kron(e2,e_1');
           kron(e2,e_m')];
    elseif BC == 3
        L=[kron(e1+beta*e2,e_1');
           kron(e1-beta*e2,e_m')];
    elseif BC == 4
        L=[kron(e1,e_1');
           kron(e1,e_m')
           kron(e2,e_1');
           kron(e2,e_m')];        
    end

   
    P=I_m2-HI2*L'*inv(L*HI2*L')*L;
    
    
%         CC=kron(A,D1)+kron(Tau_L,HI*e_1)*kron(L_L,e_1')+kron(Tau_R,HI*e_m)*kron(L_R,e_m');
%         C=kron(inv(B),E)*CC;
%         C=dt*sparse(C);
%   
if mod(ordning,2)==0    % Regular SBP
T=P*kron(A,D1)*P;
else                    % Upwind SBP
   D1=(Dp+Dm)/2;
   DI=(Dp-Dm)/2;
% DM=[0*Dp Dp;
%     Dm 0*Dm];
T=P*(kron(A,D1)+kron(I_2,DI))*P;
end
  D=sparse(kron(inv(C),I_m)*T);
   
    

temp=zeros(n,1);  % temporary solutionvector in RK4 w1,..,w4

w1=zeros(n,1);      % First step in RK
w2=zeros(n,1);      % Second step in RK
w3=zeros(n,1);      % Third step in RK
w4=zeros(n,1);      % Fourt step in RK

x=linspace(x_l,x_r,m);	  % x points
    
felet=zeros(max_itter+1,1);	% Error vector

%if BC==1
uc1=exp(-((x-t)/rr).^2)';
uc2=-exp(-((x+t)/rr).^2)';


% figure(1);
% plot(x,uc1,'r',x,uc2,'b');

exakt=zeros(n,1);	        % Analytiska l?sningen
exakt(1:m)=uc2-uc1;
exakt(m+1:n)=uc2+uc1;

V=zeros(n,2);	                % L?sningsvektorn
V(1:m,old)=uc2-uc1;
V(m+1:n,old)=uc2+uc1;
felet(1)=sqrt(h)*norm(V(:,old)-exakt);

     
Plotta_Maxwell_1D; % Plott the solution and generate a movie


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
      Plotta_Maxwell_1D; % Plott the solution and generate a movie
  end
  
exakt=zeros(n,1);	        % Analytiska l?sningen
exakt(1:m)=uc2-uc1;
exakt(m+1:n)=uc2+uc1;

% Analytic solution after t=1.8 with BC type 1
tt=2.0-t;
uc1=exp(-((x-tt)/rr).^2)';
uc2=-exp(-((x+tt)/rr).^2)';
exakt(1:m)=uc1-uc2;
exakt(m+1:n)=uc1+uc2;
felet(nr_itter+1)=sqrt(h)*norm(V(:,old)-exakt);
  
end

  %differens(i)=felet(max_itter);
  
 close(vidObj);
 tiden=linspace(0,t_1,max_itter+1);
 
 if BC==1
     disp(['The l_2 error is given by : ', num2str(felet(nr_itter+1))])   
 end
 
figure(2);
plot(x,V(1:m,old),'r',x,V(m+1:n,old),'b--','LineWidth',1);
title(['Numerical solution at t = ',num2str(t_1)]);
axis([x_l x_r -1.1 1.1]);
grid;xlabel('x');
legend('Electric (E)','Magnetic (H)')
ax = gca;          % current axes
ax.FontSize = 16;




