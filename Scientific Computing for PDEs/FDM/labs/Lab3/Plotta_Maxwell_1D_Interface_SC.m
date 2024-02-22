% Script that plots the solution from Maxwell_1D_SC_PDE and generates movie

plot(x_l,V(1:m,old),'r',x_l,V(m+1:m2,old),'b',x_r,V(m2+1:m2+m,old),'r--',x_r,V(m2+m+1:n,old),'b--','LineWidth',1);
title(['Numerical solution at t = ',num2str(t)]);
theAxes=[xb_l xb_r yb_d yb_u];
axis(theAxes);
grid;xlabel('x');
%legend('v^{(1)}','v^{(2)}')
ax = gca;          % current axes
ax.FontSize = 16;
currFrame = getframe;
writeVideo(vidObj,currFrame);