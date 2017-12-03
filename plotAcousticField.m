function [forceField,x,y] = plotAcousticField()
global nodes parameters particles

% --------------------------------------------------------------------------------------------%

%% Simulation Properties
    parameters.Tmax = 10000.0;
    parameters.dt = 0.05;
    t=0.0;
    parameters.maxSteps = round(parameters.Tmax/parameters.dt);
% --------------------------------------------------------------------------------------------%

%% Set Up Pressure Field
    nodes(:,6) = calculatePressureField();
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