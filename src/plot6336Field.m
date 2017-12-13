function [forceField,x,y] = plot6336Field()
global nodes parameters particles

%% Set Up Force Field
        y = reshape(nodes(:,2),parameters.ny+1,parameters.nx+1);
        x = reshape(nodes(:,3),parameters.ny+1,parameters.nx+1);
        pressure_6336 = imread('classedit1.PNG');
        P6336 = imresize(pressure_6336,[parameters.ny+1 parameters.nx+1]);
        P6336 = im2double(P6336(:,:,1));
%% Set Up Pressure Field
    nodes(:,6) = 5000 - 500.*P6336(:);
% --------------------------------------------------------------------------------------------%

%% Set Up Force Field
        calculateAcousticForces();
        y = reshape(nodes(:,2),parameters.ny+1,parameters.nx+1);
        x = reshape(nodes(:,3),parameters.ny+1,parameters.nx+1);
        netForcePlot = sqrt((reshape(nodes(:,7),parameters.ny+1,parameters.nx+1)).^2+(reshape(nodes(:,8),parameters.ny+1,parameters.nx+1)).^2);
        netforce_x = reshape(nodes(:,7),parameters.ny+1,parameters.nx+1);
        netforce_y = reshape(nodes(:,8),parameters.ny+1,parameters.nx+1);  
        forceField = netForcePlot;
end



