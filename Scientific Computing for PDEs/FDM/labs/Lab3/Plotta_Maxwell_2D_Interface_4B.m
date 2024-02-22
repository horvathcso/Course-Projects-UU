% Script that plots the solution from Maxwell_2D_ANM with interface and generates movie
surf(X_1,Y_1,UC2_1,'FaceLighting', 'gouraud');hold
surf(X_2,Y_2,UC2_2,'FaceLighting', 'gouraud');
surf(X_3,Y_3,UC2_3,'FaceLighting', 'gouraud');
surf(X_4,Y_3,UC2_4,'FaceLighting', 'gouraud');hold;
%surf(X,Y,Divergence,'FaceLighting', 'gouraud');
title(['Numerical solution at t = ',num2str(t)]);
xlabel('x');
ylabel('y');
colormap(jet(256))
shading interp
material dull
lighting phong
view(-70,20)
axis equal;
axis(theAxes);
camlight left;
caxis([-0.2,0.2])
ax = gca;          % current axes
ax.FontSize = 16;
currFrame = getframe;
writeVideo(vidObj,currFrame);


%theAxes_1=[x_l x_i y_d y_u -1 1];
%theAxes_2=[x_i x_r y_d y_u -1 1];