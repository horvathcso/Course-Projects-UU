function u = Initial_P1(t,xx,domain)
% Smooth function
x=xx-domain-t;
L=find(x>=0.025&x<=0.275);
%M=find(x>=0.35&x<=0.55);
%R=find(x>=0.7&x<=0.9);

m=length(xx);
u=zeros(m,1);
u(L)=exp(-200*(2*x(L)-0.3).^2) ;
u=real(u);
end

