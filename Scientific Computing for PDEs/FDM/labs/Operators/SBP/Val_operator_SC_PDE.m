%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                             %%%
%%% Different SBP operators used in the course  %%%
%%% Scientific Computing for PDE                %%%
%%%                                             %%%
%%% The different functions requires that you   %%%
%%% set the number of unknowns (m) and          %%%
%%% the grid-spacing (h)                        %%%
%%%                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (ordning==2)     
    SBP2;
    ordningstyp=' Second order';

elseif (ordning==3)  

    SBP3_Upwind;
    ordningstyp=' Third order upwind';
    
    
elseif (ordning==4)  
    SBP4;
    ordningstyp=' Fourth order';
    
elseif (ordning==5)   
    
    SBP5_Upwind;
    ordningstyp=' Fifth order upwind';
    
    
elseif (ordning==6)  
    SBP6;
    ordningstyp=' Sixth order';
    
    
elseif (ordning==7)  
    SBP7_Upwind;
    ordningstyp=' Upwind 7th order';

elseif (ordning==9)  
    SBP9_Upwind;
    ordningstyp=' Upwind 9th order';

else
    disp('Operators does not exist');
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
