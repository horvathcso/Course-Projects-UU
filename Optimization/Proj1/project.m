clear all
close all
clc;

%% Task 1 %%
load('Sharad.mat');
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','OptimalityTolerance',1e-10);
[n_opt,f1]=fminunc(@f_n,0,options)

%Plot
x=2:0.1:5;
fx=arrayfun(@(x) f_n(x), x);
plot(x,fx, n_opt,f_n(n_opt), "o")
legend("f(n)", "optimum")

%% Task 2
load('Sharad.mat');
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','OptimalityTolerance',1e-6, 'MaxFunctionEvaluations', 1.000000e+4);
%[A_opt, f2]=fminunc(@f_A,23,options)
[A_opt, f2]=fminunc(@(x) f_A((10^(-x))),50)

%Plot
figure()
x=0:10^(-26):10^(-24);
fx=arrayfun(@(x) f_A(x), x);
plot(x,fx, A_opt,f_A(A_opt), "o");
legend("f(n)", "optimum")

%% Task 3
%Task 1 redo
load('Sharad.mat');
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','OptimalityTolerance',1e-30);
[n_opt,fx]=fminunc(@f_n,1);

%Plot
x=2:0.1:5;
fx=arrayfun(@(x) f_n(x), x);
plot(x,fx, n_opt,f_n(n_opt), "o")
legend("f(n)", "optimum")

%Task 2 redo
n=n_opt;
load('Sharad.mat');
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','OptimalityTolerance',1e-100, 'MaxFunctionEvaluations', 1.000000e+10);
[A_opt, f2]=fminunc(@f_A,4,options)

%Plot
figure()
x=0:10^(-26):10^(-24);
fx=arrayfun(@(x) f_A(x), x);
plot(x,fx, A_opt,f_A(A_opt), "o");
legend("f(A)", "optimum")

%% Task 4
load('Sharad.mat');
x0=[25,1.1];
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton', 'MaxFunctionEvaluations', 1e3);
format long eng
[x,fval]=fminunc(@(x) f_An([10^(-x(1)),x(2)]),x0,options)

%{
x=0.5*10^(-25):(10^(-27)):2*10^(-25);
y=2.762:0.00005:2.765;

z=zeros(length(x),length(y));
for i = 1:length(x)
for j = 1:length(y)
 z(i,j)=f_An([x(i),y(j)]);
end
end
%size(z)
surf(y,x,z, z );
colorbar
%Plot
%}

%% Task 5
load('Sharad.mat');
f_An([10^(-25),1.1])
x0=[10^(-25),1.1];
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
[x,fval,exitflag,output]=fminunc(@f_An,x0,options)

x=0.5*10^(-25):10^(-26):2*10^(-25);
y=2.7:0.001:2.85;

z=zeros(length(x),length(y));
for i = 1:length(x)
for j = 1:length(y)
 z(i,j)=f_An([x(i),y(j)]);
end
end
size(z)
surf(y,x,z, z );
colorbar
%Plot

%% Plot

x=321.2139:0.00001:321.2141;
y=65.95:0.0005:65.98;

z=zeros(length(x),length(y));
for i = 1:length(x)
for j = 1:length(y)
 z(i,j)=f_An([10^(-x(i)),y(j)]);
end
end
size(z)
surf(y,x,z, z );
colorbar
%Plot

%% Task 7
x = lsqnonlin(@f_n7,50)
x = lsqnonlin(@f_A7,10)
x = lsqnonlin(@(x) f_A7(10^(-x)),-15)
x = lsqnonlin(@(x) f_An7([10^(-x(1)),x(2)]),[25,1.1])
%% functions

function f = f_n(n)
load('Sharad.mat');
A=10^(-25);
c=-(2*A/(n+2))*(rho*g)^n;
s=abs(dhdx).^(n-1).*dhdx;
a_guess=(c*s);
H=(a./a_guess).^(1/(n+2)); 
f=norm(H-H_obs)^2;
end

function f = f_A(A)
n = 2.7633; % set n_opt
load('Sharad.mat');
c=-2*A./(n+2);
c=c*(rho*g)^n;
s=abs(dhdx).^(n-1).*dhdx;
a_guess=(c*s);
H=(a./a_guess).^(1/(n+2)); 
f=norm(H-H_obs)^2;
end

function f = f_An(x)
A=x(1);
n=x(2);
load('Sharad.mat');
c=-2*A./(n+2);
c=c*(rho*g)^n;
s=abs(dhdx).^(n-1).*dhdx;
a_guess=(c*s);
H=(a./a_guess).^(1/(n+2)); 
f=norm(H-H_obs)^2;
end

function f = f_n7(n)
load('Sharad.mat');
A=10^(-25);
c=-(2*A/(n+2))*(rho*g)^n;
s=abs(dhdx).^(n-1).*dhdx;
a_guess=(c*s);
H=(a./a_guess).^(1/(n+2)); 
f=H-H_obs;
end

function f = f_A7(A)
n = 2.7633; % set n_opt
load('Sharad.mat');
c=-2*A./(n+2);
c=c*(rho*g)^n;
s=abs(dhdx).^(n-1).*dhdx;
a_guess=(c*s);
H=(a./a_guess).^(1/(n+2)); 
f=H-H_obs;
end

function f = f_An7(x)
A=x(1);
n=x(2);
load('Sharad.mat');
c=-2*A./(n+2);
c=c*(rho*g)^n;
s=abs(dhdx).^(n-1).*dhdx;
a_guess=(c*s);
H=(a./a_guess).^(1/(n+2)); 
f=H-H_obs;
end