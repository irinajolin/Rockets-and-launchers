clear; clc; close all;

g0 = 9.80665;
mu = 3.986e14;
Re = 6371e3;
rho0 = 1.225;
H = 8500;
Cd = 0.5;
d = 3.5;
A = pi*(d/2)^2;
theta0 = deg2rad(90); 


dryMass = 22000;
propMass = 18000;
payload = 6000;
m0 = dryMass + propMass + payload;
emptyMass = dryMass + payload;

T0 = 650000;      
Isp0 = 285;       
mdot0 = T0 / (Isp0 * g0);


CL_casos = [0, 0.1, -0.1];
names = {'C_L = 0', 'C_L = +0.1', 'C_L = -0.1'};
styles = {'k--', 'b-', 'r-'};


dt = 0.1;
tf = 400;
time = 0:dt:tf;
N = length(time);

X_all = zeros(N, 3);
Y_all = zeros(N, 3);

for c = 1:3
    CL = CL_casos(c);
    
    x = zeros(N, 1);
    y = zeros(N, 1);
    vx = zeros(N, 1);
    vy = zeros(N, 1);
    m = zeros(N, 1);
    
    
    x(1) = 0;
    y(1) = 0;
    vx(1) = 0;  % Component horitzontal inicial (m/s)
    vy(1) = 0; % Component vertical inicial (m/s)
    m(1) = m0;

    for i = 1:(N-1)

        g = mu / (Re + y(i))^2;
        rho = rho0 * exp(-y(i)/H);
        v_modul = sqrt(vx(i)^2 + vy(i)^2);

        if v_modul == 0
            theta = theta0;
        else
            theta = atan2(vy(i), vx(i));
        end
        
        % comprovar combustible
        if m(i) > emptyMass
            thrust = T0;
            flow = mdot0;
        else
            thrust = 0;
            flow = 0;
        end
        
        drag = 0.5 * rho * v_modul^2 * Cd * A;
        lift = 0.5 * rho * v_modul^2 * CL * A;
        Fx = (thrust - drag)*cos(theta) - lift*sin(theta);
        Fy = (thrust - drag)*sin(theta) + lift*cos(theta) - m(i)*g;
        
        ax = Fx / m(i);
        ay = Fy / m(i);
        
        %euler
        x(i+1)  = x(i)  + vx(i) * dt;
        y(i+1)  = y(i)  + vy(i) * dt;
        vx(i+1) = vx(i) + ax * dt;
        vy(i+1) = vy(i) + ay * dt;
        m(i+1)  = m(i)  - flow * dt;
        
        if m(i+1) < emptyMass
            m(i+1) = emptyMass;
        end

        if y(i) < 0
            y(i+1) = 0;
        end
    end
    
    X_all(:, c) = x;
    Y_all(:, c) = y;
end

figure('Name', 'Task 3 - Signed Lift Trajectory');
for c = 1:3
    plot(X_all(:,c), Y_all(:,c), styles{c}, 'LineWidth', 1.8); hold on;
end
xlabel('Posició horitzontal X [m]');
ylabel('Altitud Y [m]');
title('Task 3: Efecte del Coeficient de Sustentació (C_L) en la Trajectòria');
legend(names, 'Location', 'northwest');
grid on; axis equal;