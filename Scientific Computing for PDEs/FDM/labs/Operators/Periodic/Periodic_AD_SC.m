function [S] = Periodic_AD_SC( L,n,order )
% Create periodic artificial dissipation
% The x points are given by x(i) = a+i*h, i=0,1,...n-1
% where h=L/n and f(a)=f(b) due to periodicity. 


%h=L/n;

% S operator
% interior stencil
switch order
    case 2
        d = [1,-2,1];
        l=1;r=1;
        a=1/2;
    case 4
        d = -[1 -4 6 -4 1];
        l=2;r=2;
        a=1/12;
    case 6
        d = [1 -6 15 -20 15 -6 1];
        l=3;r=3;
        a=1/60;
    case 8        
        d = -[1 -8 28 -56 70 -56 28 -8 1];
        l=4;r=4;
        a=1/280;
    case 10
        d=[1, -10, 45, -120, 210, -252, 210, -120, 45, -10, 1];
        l=5;r=5;
        a=1/1260;
    case 12
        d = -[1, -12, 66, -220, 495, -792, 924, -792, 495, -220, 66,-12, 1];
        l=6;r=6;
        a=1/5544;

    case 106 % Spectral 6
        d = -[1, -12, 66, -220, 495, -792, 924, -792, 495, -220, 66,-12, 1];
        l=6;r=6;
        a=1/5544;
%         d=[1, -10, 45, -120, 210, -252, 210, -120, 45, -10, 1];
%         l=5;r=5;
%         a=389910724/128741750713;
end
% Q operator
v=zeros(1,n);
for i=1:r+1
    v(i)=d(i+l);
end
for i=1:l
    v(n-i+1)=d(l-i+1);
end

S=a*toeplitz(circshift(flipud(v(:)),1),v);




