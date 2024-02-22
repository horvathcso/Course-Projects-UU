% Script that plots the solution from Maxwell_1D_ANM and generates movie

plot(x,V(1:m,old),'r',x,V(m+1:n,old),'b--','LineWidth',1);
title(['Numerical solution at t = ',num2str(t)]);
theAxes=[x_l x_r y_d y_u];
axis(theAxes);
grid;xlabel('x');
%legend('v^{(1)}','v^{(2)}')
ax = gca;          % current axes
ax.FontSize = 16;
currFrame = getframe;
writeVideo(vidObj,currFrame);