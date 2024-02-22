function [H, Q, M ] = Periodic_S6_SC( L,n )
% Create periodic spectral 4th order operators for first,
% and second deivative. 
% The x points are given by x(i) = a+i*h, i=0,1,...n-1
% where h=L/n and f(a)=f(b) due to periodicity. 

h0=4203267613564094932432577824954/7049220443079284250976145948443;
h1=22618790744689935699264926210401/84590645316951411011713751381316;
h2=-2209778222820418388602425303685/42295322658475705505856875690658;
h3=-1581945765/75409415044;
h4=228992488/33235651987;
h5=27214243/33751459947;


q1=9607266784889201296177/19560081711822931675052;
q2=8866705546306148289391/97800408559114658375260;
q3=-19659090145677941034997/293401225677343975125780;
q4=127051314/37983174851;
q5=389910724/128741750713;


h=L/n;

% Q operator
l=5;
r=5;
d1=[-q5 -q4 -q3 -q2 -q1 0 q1 q2 q3 q4 q5];
v=zeros(1,n);
for i=1:r+1
    v(i)=d1(i+l);
end
for i=1:l
    v(n-i+1)=d1(l-i+1);
end

Q=toeplitz(circshift(flipud(v(:)),1),v);

% H operator
l=5;
r=5;
%d1=[1/6 2/3 1/6];
d1=[h5 h4 h3 h2 h1 h0 h1 h2 h3 h4 h5];
v=zeros(1,n);
for i=1:r+1
    v(i)=d1(i+l);
end
for i=1:l
    v(n-i+1)=d1(l-i+1);
end

H=h*toeplitz(circshift(flipud(v(:)),1),v);

% M operator
l=6;
r=6;
m0 = 0.85086800469647609167;
m1 = -0.078209094071890664434;
m2 = -0.42716031111161651324;
m3 = 0.059459556975949098755;
m4 = 0.028723540890945572833;
m5 = -0.0080958811471095540142;
m6 = -0.00015181388451598573244;

d1=[m6 m5 m4 m3 m2 m1 m0 m1 m2 m3 m4 m5 m6];
v=zeros(1,n);
for i=1:r+1
    v(i)=d1(i+l);
end
for i=1:l
    v(n-i+1)=d1(l-i+1);
end

M=-toeplitz(circshift(flipud(v(:)),1),v)/h;





% % S operator
%
% This AD does not improve, the opposite here
%
% d1=[1   -10    45  -120   210  -252   210  -120    45   -10     1];
% 
% v=zeros(1,n);
% for i=1:r+1
%     v(i)=d1(i+l);
% end
% for i=1:l
%     v(n-i+1)=d1(l-i+1);
% end
% 
% S=-1e-6/h*toeplitz(circshift(flipud(v(:)),1),v);
% 
% Q=Q+S;

