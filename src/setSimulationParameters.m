function para = setSimulationParameters()
global nodes parameters particles
    parameters.nonlinearDrag = false;
    parameters.flowX = 0.0;
    parameters.flowY = 0.0;
    parameters.PPESolver=0; % '0 - MATLABs \ , 1 - LU , 2 - GCR'
    parameters.frequency = 1000;
    parameters.PressureMap = 'Manual';
    parameters.specialField = 0;
    parameters.TimeIntegrator = 0; % 0 - Forward Euler, 1 - Trapezoidal
    parameters.Lx = 5;
    parameters.Ly = 2.5;
    parameters.dx = 0.1;
    parameters.dy= 0.1;
    parameters.nx = round(parameters.Lx/parameters.dx);
    parameters.ny = round(parameters.Ly/parameters.dy);
    parameters.rho=1;
    parameters.cspeed = 1.5;
    parameters.radius = 0.0;
    parameters.numNodes = (parameters.nx+1)*(parameters.ny+1);   
    parameters.run = 0;
    parameters.cases = 1;
    para=0;
end