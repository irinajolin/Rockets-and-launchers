clear;
clc;
close all;

%CONSTANTES
[R0,g0]=constants;           % m/s^2

%DATOS PROBLEMA 1 
Tc = 3000;       % K
Pc = 40e5;       % Pa
molar = 0.025;    % kg/mol
gamma = 1.2;     % -
epsilon=11;
D_throat=0.2; %m
Pa = 1e5;        % Pa

% CALCULOS PREVIOS
[At,Ae]=geometry(D_throat,epsilon);
disp(At);
disp(Ae);

% EJERCICIO 1

% Apartado a: presion de salida --> decimos que no tenemos pc para poder
% sacar el ratio 
[~,Pr_sup, Pr_sub]= area_ratio_press(epsilon,[], [], gamma)
Pe= Pr_sup*Pc; % usamos pr_sup porque estamos estudiando la salida supersonica de una tobera convergente ideal
fprintf ('exit pressure = %6f bar.\n ',Pe/1e5);
%comprobamos summerfield Pe/Pa >= 0.4
ratio_summerfield(Pe,Pa)

% apartado b --> mass flow para Match =1 en throat
[Rs,Cstar]=cee_star(R0,molar, Tc, gamma);
mass_flow = mdot(Pc,At, Cstar);
fprintf('Mass flow rate = %.6f kg/s\n', mass_flow);

% apartado c  --> exit match number 
Ar=epsilon;% en este caso es igual a epsilon porque queremos en Mexit
[~,M]=area_ratio(Ar,[],gamma);
Me=M;
fprintf('Exit Mach = %.6f\n', Me);

% apartado d (plot as a function od the Match nº along the nozzle , P, T,
% Density, An, Velocity gas, flow rate, 
% creamos vector con los valores de Match
M_vec = linspace (0.1,M,200);
% temperaturas 
[Tr_vec,~] = ratio_temp([], M_vec, gamma);
T_vec= Tc./Tr_vec;

% presiones 
[Pr_vec,~]= pressure_ratio ( M_vec, [], gamma);
P_vec= Pc./Pr_vec;

% density
[rho_c,~,~,~,~] = ideal_gas([],Rs,Pc,Tc,[],[]);
[rho_r_vec,~] = density_ratio(M_vec,[],gamma);
rho_vec = rho_c ./ rho_r_vec;
%[rho_vec,~,~,~,~] = ideal_gas ([], Rs,P_vec, T_vec,[],[]); --> otra forma

% area in the nozzle 

[Ar_vec,~]= area_ratio([],M_vec,gamma);% calculamos el ratio A/At para cada Match 
% calcular el area real de cada seccion
A_vec= Ar_vec.*At;

%velocity gas 
[a_vec,~, v_vec]= Mach (gamma, Rs,T_vec,[], M_vec);

% mass flow
mdot_vec= mdot([],[],[],rho_vec,A_vec,v_vec);

%GRAFICO TEMP VS MATCH
figure
subplot(3,2,1);
plot(M_vec, T_vec);
xlabel('Mach number'); ylabel('Temperature ');
title('Temperature along nozzle'); grid on;
xline(1, '--', 'Throat');
% GRAFICO P VS MATCH 
subplot(3,2,2);
plot(M_vec, P_vec);
xlabel('Mach number'); ylabel('Pressure');
title('Pressure along nozzle'); grid on;
xline(1, '--', 'Throat');
%GRAFICO RHO VS MATCH 
subplot(3,2,3);
plot(M_vec,rho_vec);
xlabel('Mach number');
ylabel('Density [kg/m^3]');
title('Density along nozzle');
grid on;
xline(1, '--', 'Throat');
% GRAFICO AREA VS MATCH
subplot(3,2,4);
plot(M_vec,A_vec);
xlabel('Mach number');
ylabel('Area [m^2]');
title('Nozzle area along nozzle');
grid on;
xline(1, '--', 'Throat'); 

% GAS VELOCITY VS MACH
subplot(3,2,5);
plot(M_vec,v_vec);
xlabel('Mach number');
ylabel('Gas velocity [m/s]');
title('Gas velocity along nozzle');
grid on;
xline(1,'--','Throat');

subplot(3,2,6);
plot(M_vec,mdot_vec);
xlabel('Mach number');
ylabel('Mass flow rate [kg/s]');
title('Mass flow rate along nozzle');
grid on;
xline(1,'--','Throat');
% check the flow rate is cte  and agreement with Cstar
% Check mass flow conservation

error_rel = max(abs(mdot_vec - mass_flow)) / mass_flow;

fprintf('Mass flow rate = %.6f kg/s\n', mass_flow);
fprintf('Maximum relative error = %.3e\n', error_rel);

% APARTADO F 
%thrust cuando el cohete esta en lanzamiento , ( a presion atmosferica) 
[Ve,~] = exit_velocity([],[],R0,molar, Tc, gamma, Pc, Pe);
[T, ~, ~]= thrust(mass_flow,Ve,Ae,Pe,Pa);
% Results
fprintf('\n--- THRUST AT LAUNCH ---\n');
fprintf('Total thrust = %.2f kN\n',T/1000);



%PROBLEM 2
%mantenemos todos los parametros excepto epsilon

% APARTADO A
%plot in function of epsilon, both terms of the thrust(momentum thrust, pressure thrust) , the total thrust,
%exit pressure , reasonable range of area expansion ratios 
% queremos probar diferentes toberas que tienen la misma garganta pero
% distintas areas de salida 
epsilon_vec =linspace(1.05,25,200); % empezamos un poco x encima de 1 para evitar el punto de la garganta 
% calculamos primero la presion en exit 
Pe_vec = zeros(size(epsilon_vec));
% calculem el ratio pe/pc per cada epsilon 
for i= 1:length (epsilon_vec)
    [~, Pr_sup, ~]= area_ratio_press(epsilon_vec(i),[],[],gamma);% a la salida tenemos flujo supersonico
    Pe_vec(i)= Pr_sup*Pc; % pression de salida 
end
% calculamos la velocidad de salida 
[ve_vec,~]= exit_velocity([],[],R0, molar,Tc,gamma,Pc,Pe_vec);
% calculamos el area de salida
Ae_vec = epsilon_vec.*At;
[T2_vec, T2_momentum_vec,T2_pressure_vec]=thrust(mass_flow,ve_vec,Ae_vec,Pe_vec,Pa);


% APARTADO B --> marcar en el total thrust point (adapted nozzle,
% summerfield point i schmucker point
% adapted nozzle Pe=Pa --> cual es el epsilon para el cual la tobera esta
% adapted nozzle 
Pr_ad=Pc/Pa;
[~,Me_ad]=pressure_ratio([],Pr_ad,gamma);% encontramos el mach para el que se cumple esto
[epsilon_ad,~]=area_ratio([],Me_ad,gamma);
fprintf('Adapted nozzle epsilon = %.4f\n',epsilon_ad);
% criterio summerfield Pe/Pa= 0.4
Pe_sum=ratio_summerfield([],Pa);
Pr_sum=Pc/Pe_sum;
[~,Me_sum]=pressure_ratio([],Pr_sum,gamma);
[epsilon_sum,~]=area_ratio([],Me_sum,gamma);
fprintf('Summerfield epsilon = %.4f\n',epsilon_sum);

%criterio schmucker 

[~,Me_sch_vec]=pressure_ratio([],Pc./Pe_vec,gamma); % un mach correspondiente para cada epsilon
[Pr_sch_vec,~] = schmucker([],Me_sch_vec); % Pe/Pa
Pr_actual_vec = Pe_vec ./ Pa;
% queremos encontar donde Pr(actual)=Pr(sch)
[~,idx_sch] = min(abs(Pr_actual_vec-Pr_sch_vec));

% Epsilon corresponent
epsilon_sch = epsilon_vec(idx_sch);

fprintf('Schmucker epsilon = %.4f\n',epsilon_sch);

%GRAFICOS 

figure;

% THRUST VS EPSILON
subplot(1,2,1);

plot(epsilon_vec,T2_momentum_vec/1000);
hold on;
plot(epsilon_vec,T2_pressure_vec/1000);
plot(epsilon_vec,T2_vec/1000);
xline(epsilon_ad,'--k','Adapted nozzle'); % añadimos lo que tenemos al final de adapted nozzle
xline(epsilon_sum,'--r','Summerfield');% añadimos summerfield
xline(epsilon_sch,'--','Schmucker'); % schmucker
xlabel('Expansion ratio epsilon');
ylabel('Thrust [kN]');
title('Thrust vs expansion ratio');
legend('Momentum thrust','Pressure thrust','Total thrust');
grid on;

% EXIT PRESSURE VS EPSILON
subplot(1,2,2);

plot(epsilon_vec,Pe_vec/1e5);

xlabel('Expansion ratio epsilon');
ylabel('Exit pressure [bar]');
title('Exit pressure vs expansion ratio');
grid on;
