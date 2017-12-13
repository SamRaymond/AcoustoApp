function part= initializeParticles()
global nodes parameters particles
particles = zeros(parameters.numParticles,6);% 1 x,2 y,3 vx,4 vy,5 ax,6 ay

for i = 1:parameters.numParticles
   particles(i,1) =parameters.Lx*rand(1);%%%Lx/2 + (0.5-rand(1))*7*rand(1);%Lx*rand(1);%
   particles(i,2) =parameters.Ly*rand(1);%Ly/2+ (0.5-rand(1))*4*rand(1);%Ly*rand(1);%
end
part=0.0;
end