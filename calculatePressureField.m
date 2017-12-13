function P = calculatePressureField()
global nodes parameters particles


cases = parameters.cases;
L = parameters.Lx;
H = parameters.Ly; 
N = parameters.nx; 
M = parameters.ny;
dx = parameters.dx;
dy = parameters.dy;
x = reshape(nodes(:,2),parameters.ny+1,parameters.nx+1);
y = reshape(nodes(:,3),parameters.ny+1,parameters.nx+1);
lambda = parameters.frequency; 
k = 2 * pi / lambda; 
% Setting up the matrices for system (K + k^2 I) P = F
% K
K_y = spdiags(ones(M+1,1)*[1 -2 1],-1:1,M+1,M+1);
K_x = spdiags(ones(N+1,1)*[1 -2 1],-1:1,N+1,N+1);
I_y = speye(N+1,N+1); 
I_x = speye(M+1,M+1); 

switch cases 
    case 1
        K_y(end,end-1) = 2;                 % Left or right boundary condition    
        K_y(1,2) = 2;                       % Left or right boundary condition
    case 2
        K_x(end,end-1) = 2;                 % Bottom Neuman boundary condition                                    
        K_x(1,2) = 2;                       % Top boundary condition 
        K_y(end,end-1) = 2;                 % Left or right boundary condition    
        K_y(1,2) = 2;                       % Left or right boundary condition
    case 3
        K_x(end,end-1) = 2;                 % Bottom boundary condition                                    
        K_x(1,2) = 2;                       % Top boundary condition 
        K_y(end,end-1) = 2;                 % Left or right boundary condition    
        K_y(1,2) = 2;                       % Left or right boundary condition 
    case 4
        
    otherwise
end

K = (1/dy^2).*kron(I_y,K_y)+(1/dx^2).*kron(K_x,I_x);
% I 
I = speye(size(K)); 
% A
A = K + k^2 .* I;
% F 
switch cases 
    case 1 
for j = 1:M+1
    for i = 1:N+1
        index = (i-1) * (M+1) + j;
        if (j == 1) && (x(j,i) > (L/2-1)) && (x(j,i) < (L/2+1))  
            F(index) = -20; 
        else
            F(index) = 0; 
        end
    end 
end 
    case 2
for j = 1:M+1
    for i = 1:N+1
        index = (i-1) * (M+1) + j;
        if (j == 1) && (x(j,i) > (L/2-1)) && (x(j,i) < (L/2+1))  
            F(index) = -10; 
        else
            F(index) = 0; 
        end
    end 
end 
    case 3
for j = 1:M+1
    for i = 1:N+1
        index = (i-1) * (M+1) + j; 
        if ((j == 1) || (j == M+1)) || ((i == 1) || (i == N+1))
            F(index) = -10; 
        else
            F(index) = 0; 
        end 
    end 
end 
    case 4
for j = 1:M+1
    for i = 1:N+1
        index = (i-1) * (M+1) + j; 
        if (j > 11) && (j < M-9)
            if (i/10 < 4) 
                F(index) = 2; 
            elseif (i/10 < 8) 
                F(index) = -2; 
            elseif (i/10 < 12)
                F(index) = 2; 
            elseif (i/10 < 16) 
                F(index) = -2; 
            else
                F(index) = 2; 
            end 
        else 
            F(index) = 0; 
        end
    end 
end 
    otherwise
end

% Solving the system A P = F
switch parameters.PPESolver
    case 0 
    % Backslash
    P = A \ F'; 
    case 1
    % LU 
    [L,U] = lu(A);
    yp = L \ F'; 
    xp = U \ yp;
    P = xp; 
    case 2
    % CGR
    %D = diag(diag(A));
    [x1, r_norms1] = tgcr(A,F',10^-4,10000);        % No preconditioning
    %[x2, r_norms2] = tgcr_p(A,F',D,10^-4,10000);    % GCR with D perconditioning 
    P = x1;
    otherwise
end


P = 0.1*P./(dx*dy);


end