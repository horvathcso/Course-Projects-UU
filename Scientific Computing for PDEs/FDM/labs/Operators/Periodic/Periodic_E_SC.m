function [H, Q, M ] = Periodic_E_SC( L,n,order )
% Create periodic spectral 6th order operators for first,
% and second deivative. 
% The x points are given by x(i) = a+i*h, i=0,1,...n-1
% where h=L/n and f(a)=f(b) due to periodicity. 


h=L/n;

% Q operator
% interior stencil
switch order
    case 2
        d = [-1/2,0,1/2];
        l=1;r=1;
    case 4
        d = [1/12,-2/3,0,2/3,-1/12];
        l=2;r=2;
    case 6
        d = [-1/60,3/20,-3/4,0,3/4,-3/20,1/60];
        l=3;r=3;
    case 8
        d = [1/280,-4/105,1/5,-4/5,0,4/5,-1/5,4/105,-1/280];
        l=4;r=4;
    case 10
        d = [-1/1260,5/504,-5/84,5/21,-5/6,0,5/6,-5/21,5/84,-5/504,1/1260];
        l=5;r=5;
    case 12
        d = [1/5544,-1/385,1/56,-5/63,15/56,-6/7,0,6/7,-15/56,5/63,-1/56,1/385,-1/5544];
        l=6;r=6;
end
% Q operator
v=zeros(1,n);
for i=1:r+1
    v(i)=d(i+l);
end
for i=1:l
    v(n-i+1)=d(l-i+1);
end

Q=toeplitz(circshift(flipud(v(:)),1),v);

% H operator
l=1;
r=1;
%d1=[1/6 2/3 1/6];
d1=[0 1 0];
v=zeros(1,n);
for i=1:r+1
    v(i)=d1(i+l);
end
for i=1:l
    v(n-i+1)=d1(l-i+1);
end

H=h*toeplitz(circshift(flipud(v(:)),1),v);


% M operator
% interior stencil
switch order
    case 2
        m0=-2;m1=1;
        d = [m1,m0,m1];
        l=1;r=1;
    case 4
        m0=-5/2;m1=4/3;m2=-1/12;
        d = [m2, m1,m0,m1,m2];
        l=2;r=2;
    case 6
        m0=-49/18;m1=3/2;m2=-3/20;m3=1/90;
        d = [m3,m2,m1,m0,m1,m2,m3];
        l=3;r=3;
    case 8
        m0 = 205/72; m1 = -8/5; m2 = 1/5; m3 = -8/315; m4 = 1/560;
        d = -[m4,m3,m2,m1,m0,m1,m2,m3,m4];
        l=4;r=4;
    case 10
        m0 = 5269/1800; m1 = -5/3; m2 = 5/21; m3 = -5/126; m4 = 5/1008; m5 = -1/3150;
        d = -[m5,m4,m3,m2,m1,m0,m1,m2,m3,m4,m5];
        l=5;r=5;
    case 12
        m0 = 5369/1800; m1 = -12/7; m2 = 15/56; m3 = -10/189; m4 = 1/112; m5 = -2/1925; m6 = 1/16632;
        d = -[m6,m5,m4,m3,m2,m1,m0,m1,m2,m3,m4,m5,m6];
        l=6;r=6;
end
% Q operator
v=zeros(1,n);
for i=1:r+1
    v(i)=d(i+l);
end
for i=1:l
    v(n-i+1)=d(l-i+1);
end

M=toeplitz(circshift(flipud(v(:)),1),v)/h;




