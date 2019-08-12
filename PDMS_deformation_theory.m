for i = 1:10
    F = 0.1*i;
    eta = 0.45;
    E = 1;
    x = linspace(0, 10, 100);

    u_x = x - (x.^2 + 4*((1+eta)*(1-2*eta)*F)/(2*pi*E)).^0.5;
    u_z = F*(1-eta^2)./(pi*E*(x-u_x));

    plot(x,-u_z,-x,-u_z)
    hold on;
end
