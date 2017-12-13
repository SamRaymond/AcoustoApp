function res = calculateAcousticForces()
global parameters nodes particles
numNodes = parameters.numNodes;
nx = parameters.nx+1;
ny = parameters.ny+1;
dy = parameters.dy;
dx = parameters.dx;
Fx = zeros(numNodes,1);
Fy = zeros(numNodes,1);
rho = parameters.rho;
c = parameters.cspeed;
for n = ny+1:numNodes-ny
    if(parameters.specialField)
   Fy(n) =  200-50*((nodes(n-1,6))^2 -(nodes(n+1,6)^2))/ 2*dy;
   Fx(n) =  200-50*((nodes(n-1,6))^2 - (nodes(n+1,6)^2))/ 2*dx;
    else
           Fy(n) =  -(1/(2*rho*c^2))* (nodes(n-1,6)^2 - nodes(n+1,6)^2)/ 2*dy;
           Fx(n) =  -(1/(2*rho*c^2))* (nodes(n-ny,6)^2 - nodes(n+ny,6)^2)/ 2*dx;
    end
end
% Left boundary 
%for n = 1:2*ny
for n = 2*ny:-1:1
   %Fy(n) = Fy(n+ny); 
   %Fx(n) = Fx(n+ny); 
   Fy(n) = 0; 
   Fx(n) = 0; 
end
% Right boundary
for n = numNodes-2*ny+1:numNodes
   Fy(n) = Fy(n-ny); 
   Fx(n) = Fx(n-ny);
   %Fy(n) = 0; 
   %Fx(n) = 0; 
end
% top boundary
for n = 1:ny:numNodes-ny+1
   Fy(n) = Fy(n+1); 
   Fx(n) = Fx(n+1);
   %Fy(n) = 0; 
   %Fx(n) = 0;   
end
% Bottom boundary 
for n = ny:ny:numNodes-ny
   Fy(n) = Fy(n-1); 
   Fx(n) = Fx(n-1);
   %Fy(n) = 0; 
   %Fx(n) = 0;
end
nodes(:,7) = Fx;
nodes(:,8) = Fy;
res = 0;

end