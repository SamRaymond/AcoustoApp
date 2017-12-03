function h = runSimulation()
global nodes parameters particles

        %% Calculate Forces from Nodes
        calculateParticleAcceleration();
        %% Update Velocity
        updateParticleVelocities();
        %% Update Position
        updateParticlePositions();
        %% Visualisation during simulation    
        %xplot = reshape(nodes(:,2),parameters.nx,parameters.ny);
        %yplot = reshape(nodes(:,3),parameters.nx,parameters.ny);
        %netForcePlot = abs(reshape(nodes(:,7),parameters.nx,parameters.ny) + reshape(nodes(:,8),parameters.nx,parameters.ny));

 h = 0;
end