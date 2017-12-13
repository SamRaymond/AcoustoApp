function res = updateParticlePositions()
global nodes parameters particles
%     x_pos = zeros(parameters.numParticles,1);
%     y_pos = zeros(parameters.numParticles,1);
    for i = 1:parameters.numParticles
    particles(i,1) = particles(i,1) + parameters.dt*particles(i,3); % x
    particles(i,2) = particles(i,2) + parameters.dt*particles(i,4); % y
    end
%     
%     particles(:,1)=x_pos(:);
%     particles(:,2)=y_pos(:);
    res = 0;
end