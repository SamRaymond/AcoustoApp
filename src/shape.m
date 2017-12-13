function N = shape(x_node,x_particle,dx)

if(abs(x_node - x_particle) > dx)
    N = 0.0;
else
    N = 1.0 - abs(x_node - x_particle)/dx ;
end

end