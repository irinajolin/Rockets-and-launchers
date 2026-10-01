clear;
clc;
close all;

%% CONSTANTS
g0 = 9.81;       % Gravity [m/s^2]

%% VEHICLE
m0 = 115000;     % Initial mass [kg]

%% ENGINES
% Original engine
T1 = 1.30e6;     % Thrust [N]
Isp1 = 300;      % Specific impulse [s]

% Higher thrust engine
T2 = 1.55e6;     % Thrust [N]
Isp2 = 300;      % Same Isp

% Higher Isp engine
T3 = 1.30e6;     % Same thrust
Isp3 = 340;      % Higher Isp


%% MASS FLOW RATE 
% mdot = T / (Isp * g0) (cuanto combustible consume cada motor por segundo)
mdot1 = T1 / (Isp1 * g0);
mdot2 = T2 / (Isp2 * g0);
mdot3 = T3 / (Isp3 * g0);


%% TIME
dt = 0.1;
t = 0:dt:20;
N = length(t);


%% INITIALIZE VARIABLES
m1 = zeros(1,N);
m2 = zeros(1,N);
m3 = zeros(1,N);

a1 = zeros(1,N);
a2 = zeros(1,N);
a3 = zeros(1,N);

v1 = zeros(1,N);
v2 = zeros(1,N);
v3 = zeros(1,N);

h1 = zeros(1,N);
h2 = zeros(1,N);
h3 = zeros(1,N);


%% INITIAL MASS
m1(1) = m0;
m2(1) = m0;
m3(1) = m0;


%% SIMULATION
for i = 1:N-1

    % Acceleration
    % a = T/m - g0
    a1(i) = T1/m1(i) - g0;
    a2(i) = T2/m2(i) - g0;
    a3(i) = T3/m3(i) - g0;

    % Forward Euler: velocity
    v1(i+1) = v1(i) + a1(i)*dt;
    v2(i+1) = v2(i) + a2(i)*dt;
    v3(i+1) = v3(i) + a3(i)*dt;

    % Forward Euler: altitude
    h1(i+1) = h1(i) + v1(i)*dt;
    h2(i+1) = h2(i) + v2(i)*dt;
    h3(i+1) = h3(i) + v3(i)*dt;

    % Propellant consumption
    m1(i+1) = m1(i) - mdot1*dt;
    m2(i+1) = m2(i) - mdot2*dt;
    m3(i+1) = m3(i) - mdot3*dt;

end


% Last acceleration value
a1(end) = T1/m1(end) - g0;
a2(end) = T2/m2(end) - g0;
a3(end) = T3/m3(end) - g0;


%% PROPELLANT USED
prop1 = m0 - m1;
prop2 = m0 - m2;
prop3 = m0 - m3;


%% RESULTS
fprintf('INITIAL ACCELERATION\n')
fprintf('Original:      %.2f m/s^2\n', a1(1))
fprintf('Higher thrust: %.2f m/s^2\n', a2(1))
fprintf('Higher Isp:    %.2f m/s^2\n\n', a3(1))

fprintf('MASS FLOW RATE\n')
fprintf('Original:      %.2f kg/s\n', mdot1)
fprintf('Higher thrust: %.2f kg/s\n', mdot2)
fprintf('Higher Isp:    %.2f kg/s\n', mdot3)


%% GRAPH 1 - ACCELERATION
figure

plot(t,a1,'LineWidth',1.5)
hold on
plot(t,a2,'LineWidth',1.5)
plot(t,a3,'LineWidth',1.5)

xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')
title('Acceleration')

legend('Original','Higher thrust','Higher Isp')

grid on


%% GRAPH 2 - VELOCITY
figure

plot(t,v1,'LineWidth',1.5)
hold on
plot(t,v2,'LineWidth',1.5)
plot(t,v3,'LineWidth',1.5)

xlabel('Time [s]')
ylabel('Velocity [m/s]')
title('Velocity')

legend('Original','Higher thrust','Higher Isp')

grid on


%% GRAPH 3 - ALTITUDE
figure

plot(t,h1,'LineWidth',1.5)
hold on
plot(t,h2,'LineWidth',1.5)
plot(t,h3,'LineWidth',1.5)

xlabel('Time [s]')
ylabel('Altitude [m]')
title('Altitude')

legend('Original','Higher thrust','Higher Isp')

grid on


%% GRAPH 4 - PROPELLANT USED
figure

plot(t,prop1,'LineWidth',1.5)
hold on
plot(t,prop2,'LineWidth',1.5)
plot(t,prop3,'LineWidth',1.5)

xlabel('Time [s]')
ylabel('Propellant used [kg]')
title('Propellant consumption')

legend('Original','Higher thrust','Higher Isp')

grid on