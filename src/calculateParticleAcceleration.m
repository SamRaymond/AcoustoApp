function res = calculateParticleAcceleration()
global nodes parameters particles
% ax = zeros(parameters.numParticles,1);
% ay = zeros(parameters.numParticles,1);
% nodeIdx = zeros(4,1);
    for i = 1:parameters.numParticles
        particles(i,5)=0.0;particles(i,6)=0.0;
        % Interpolate the pressure field onto the particle forces
        nidx_x = floor(particles(i,1)/parameters.dx) + 1 ;
        nidx_y = parameters.ny - floor(particles(i,2)/parameters.dy) + 1 ;
        
        nidx = (nidx_y) + (parameters.ny+1)*(nidx_x);
        nodeIdx(1) = nidx  - 1 ;
        nodeIdx(2) = nidx ;
        nodeIdx(3) = nidx - parameters.ny -2;
        nodeIdx(4) = nidx - parameters.ny -1; 
        for o = 1:4
            if((nodeIdx(o) >parameters.numNodes) || (nodeIdx(o) <1) )
                nodeIdx(o) =1;
            end
        end
      ax = 0;ay = 0;  
        for nd = 1:4
            n = nodeIdx(nd);
            ndx = nodes(n,2);
            px = particles(i,1);
            dx = parameters.dx;
            Nx=shape(px,ndx,dx);
            ndy = nodes(n,3);
            py = particles(i,2);
            dy = parameters.dy;
            Ny=shape(py,ndy,dy);
            ax = ax + nodes(n,7)*Nx*Ny;%/(dx*dy*dx); %ax = ax + N Ax
            ay = ay + nodes(n,8)*Nx*Ny;%/(dy*dx*dx); %ay = ay + N Ay
        end
            particles(i,5) = ax;
            particles(i,6) = ay;
% %         pause;
%         for n = 1:parameters.numNodes
%             Nx=shape(particles(i,1),nodes(n,2),parameters.dx);
%             Ny=shape(particles(i,2),nodes(n,3),parameters.dy);
%             particles(i,5) = particles(i,5) + nodes(n,7)*Nx*Ny; %ax = ax + N Ax
%             particles(i,6) = particles(i,6) + nodes(n,8)*Nx*Ny; %ay = ay + N Ay
%         end
    end


res = 0;
end