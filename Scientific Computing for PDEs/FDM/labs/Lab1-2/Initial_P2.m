function u = Initial_P2(t,xx,domain)
% Non-smooth function
x=xx-domain-t;
L=find(x>=0.025&x<=0.275);
M=find(x>=0.35&x<=0.55);
R=find(x>=0.7&x<=0.9);

m=length(xx);
u=zeros(m,1);
u(L)=exp(-200*(2*x(L)-0.3).^2) ;
u(M)=1;
u(R)=sqrt(1-((2*x(R)-1.6)/0.2).^2);
u=real(u);
end

