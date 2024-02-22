% Script that plots the solution from ONEWAY_ANM and generates movie

%plot(x,exact,'r',x,V,'b--','LineWidth',1);
plot(x,V,'b','LineWidth',1);
xlabel('x');
ylabel('u');
title(['Numerical solution at t = ',num2str(t), ' Order = ', num2str(order)])
%title(['Numerical solution at t = ',num2str(t),ordningstyp])
axis(theAxes);
ax = gca; % current axes
ax.FontSize = 16;
currFrame = getframe;
writeVideo(vidObj,currFrame);