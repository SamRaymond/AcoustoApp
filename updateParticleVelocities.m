function res = updateParticleVelocities()
global nodes parameters particles
% x_vel = zeros(parameters.numParticles,1);
% y_vel = zeros(parameters.numParticles,1);

switch parameters.TimeIntegrator
    case 0
            for i = 1:parameters.numParticles
           %% Forward Euler: v_new = v_old + ( Acoustic Force - Drag Force)*dt 
            v0x = parameters.flowX; 
            v0y =  parameters.flowY;
            dragNLx = 0.0;
            dragNLy = 0.0;
            if(parameters.nonlinearDrag)
            vmag = sqrt(particles(i,3).^2+particles(i,4).^2);
                if(particles(i,3) ~= 0.0)
                    dragNLx = 0.001*vmag^2;
                end
                if(particles(i,4) ~= 0.0)
                    dragNLy = 0.001*vmag^2;
                end
            end
            
            particles(i,3) = v0x + particles(i,3) + parameters.dt*(particles(i,5) - dragNLx - 7.1*particles(i,3));  %vx
            particles(i,4) = v0y + particles(i,4) + parameters.dt*(particles(i,6) - dragNLy - 7.1*particles(i,4));  %vy
            end

   case 1
        %% Trapezoidal Solver
        if(parameters.nonlinearDrag)
            % Nonlinear Trapezoidal Solver
            for i = 1:parameters.numParticles
            A_np1 = (1.0 - (parameters.dt/2.0)*6*pi*parameters.radius);
            A_nx = particles(i,3) +  (parameters.dt/2.0).*(particles(i,5) - 6*pi*parameters.radius.*particles(i,3)- 5.1*particles(i,3));
            A_ny = particles(i,4) +  (parameters.dt/2.0).*(particles(i,6) - 6*pi*parameters.radius.*particles(i,4) - 5.1*particles(i,4));
            particles(i,3) = A_nx/A_np1;
            particles(i,4) = A_ny/A_np1;
            end  
        else
            % Linear Trapezoidal Solver
            for i = 1:parameters.numParticles
            A_np1 = (1.0 - (parameters.dt/2.0)*6*pi*parameters.radius);
            A_nx = particles(i,3) +  (parameters.dt/2.0).*(particles(i,5) - 6*pi*parameters.radius.*particles(i,3)- 5.1*particles(i,3));
            A_ny = particles(i,4) +  (parameters.dt/2.0).*(particles(i,6) - 6*pi*parameters.radius.*particles(i,4) - 5.1*particles(i,4));
            particles(i,3) = A_nx/A_np1;
            particles(i,4) = A_ny/A_np1;
            end
        end
        
end

res = 0;
end

