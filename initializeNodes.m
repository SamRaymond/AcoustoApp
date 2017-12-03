function nds = initializeNodes()
global nodes parameters particles
parameters.nx = round(parameters.Lx/parameters.dx);
parameters.ny = round(parameters.Ly/parameters.dy);
parameters.numNodes = (parameters.nx+1)*(parameters.ny+1);   
nodes = zeros(parameters.numNodes,8); % 1-id, 2-x, 3-y, 4-vx, 5-vy, 6-P, 7-Fx, 8-Fy, 9-dP
    %count = 1;
    %for j = 1:parameters.ny
        %for i = 1:parameters.nx
        %x = parameters.dx*i;
        %y = parameters.dy*j;
        %nodes(count,2)=x;
        %nodes(count,3)=y;
        %count = count +1;
        %end
    %end
    
     N = parameters.nx; 
     M = parameters.ny;
     dx = parameters.dx;
     dy = parameters.dy;
     [x, y] = meshgrid(dx.*(0:1:N),dy.*(M:-1:0));
     x = x(:);
     y = y(:); 
     nodes(:,2) = x;
     nodes(:,3) = y;
     nds=0;
end