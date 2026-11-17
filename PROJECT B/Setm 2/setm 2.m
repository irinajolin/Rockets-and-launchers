clear;
clc;
close all;

% PROBLEM 1A - STARSHIP CO2 EMISSIONS

% Propellant capacities - SpaceX [kg]
m_prop_booster = 3650e3;
m_prop_starship = 1600e3;

% Molecular masses [kg/kmol]
M_CH4 = 16;
M_O2 = 32;
M_CO2 = 44;
M_CO = 28;
M_H2O = 18;

% Reference Raptor mixture ratio - FAA 2019
OF = 3.60;  % m_O2/m_CH4


% 1A.1 - PROPELLANT MASSES

% Super Heavy
[m_CH4_booster,m_O2_booster] = propellant_masses(m_prop_booster,OF);

% Starship
[m_CH4_starship,m_O2_starship] = propellant_masses(m_prop_starship,OF);


% 1A.2 - CO2 EMISSIONS

% Super Heavy
[m_CO2_booster,m_CO2_total_booster] = combustion_methane(m_CH4_booster,m_O2_booster, M_CH4,M_O2,M_CO2);

% Starship
[m_CO2_starship,m_CO2_total_starship] = combustion_methane(m_CH4_starship,m_O2_starship, M_CH4,M_O2,M_CO2);

% Total emissions for one complete vehicle
m_CO2 = m_CO2_booster + m_CO2_starship;

m_CO2_total = m_CO2_total_booster + m_CO2_total_starship;


% 1A.3 - RESULTS

fprintf('\n--- PROBLEM 1A ---\n');

fprintf('\nSUPER HEAVY\n');
fprintf('Direct CO2 = %.2f tonnes\n', m_CO2_booster/1000);
fprintf('Potential CO2 = %.2f tonnes\n', m_CO2_total_booster/1000);

fprintf('\nSTARSHIP\n');
fprintf('Direct CO2 = %.2f tonnes\n', m_CO2_starship/1000);
fprintf('Potential CO2 = %.2f tonnes\n', m_CO2_total_starship/1000);

fprintf('\nTOTAL STARSHIP / SUPER HEAVY\n');
fprintf('Direct CO2 = %.2f tonnes\n',m_CO2/1000);
fprintf('Potential CO2 = %.2f tonnes\n',m_CO2_total/1000);


% 1A.4 - MASS CONSERVATION VERIFICATION

% Super Heavy
[error_prop_booster,error_comb_booster] = mass_conservation(m_prop_booster, m_CH4_booster,m_O2_booster,m_CO2_booster, M_CH4,M_CO2,M_CO,M_H2O);

% Starship
[error_prop_starship,error_comb_starship] = mass_conservation(m_prop_starship, ...
    m_CH4_starship,m_O2_starship,m_CO2_starship, M_CH4,M_CO2,M_CO,M_H2O);

fprintf('\nMASS CONSERVATION VERIFICATION\n');

fprintf('Booster propellant error = %.3e kg\n',error_prop_booster);
fprintf('Booster combustion error = %.3e\n', error_comb_booster);

fprintf('Starship propellant error = %.3e kg\n', error_prop_starship);
fprintf('Starship combustion error = %.3e\n', error_comb_starship);


% 1A.5 - CO2 VOLUME COMPARISON

% Reference conditions
T_ref = 298.15;   % K
P_ref = 101325;   % Pa

% Universal and specific gas constants
R0 = 8314.462618;    % J/(kmol*K)
Rs_CO2 = R0/M_CO2;    % J/(kg*K)

% Calculate CO2 density
[rho_CO2,~,~,~,~] = ideal_gas([],Rs_CO2,P_ref,T_ref,[],m_CO2_total);

% Calculate equivalent CO2 volume
[~,~,~,V_CO2,~] = ideal_gas(rho_CO2,Rs_CO2,P_ref,T_ref,[],m_CO2_total);

% Swimming pool comparison
V_pool = 50*25*2;  % m^3

n_pools = V_CO2/V_pool;

fprintf('\nCO2 COMPARISON - PROBLEM 1A\n');
fprintf('CO2 density = %.3f kg/m3\n',rho_CO2);
fprintf('CO2 volume = %.2f m3\n',V_CO2);
fprintf('Equivalent swimming pools = %.2f\n',n_pools);


% PROBLEM 1B - STARLINK CO2 EMISSIONS

% Launches identified as Starlink missions
% Cut-off: November 17, 2026

years = 2019:2026;

% Falcon 9 launches by year
N_falcon9 = [2 14 17 34 63 89 122 85];

% Starship launches by year
N_starship = [0 0 0 0 0 0 0 2];

% Total number of launches
N_F9_total = sum(N_falcon9);
N_starship_total = sum(N_starship);


% 1B.1 - FALCON 9 PROPELLANT DATA

% Reference propellant masses from LBNL [kg/launch]
m_RP1_F9 = 155893;
m_LOX_F9 = 362607;

% Total propellant mass per launch
m_prop_F9 = m_RP1_F9 + m_LOX_F9;

% RP-1 is modelled as C12H26
M_RP1 = 170;  % kg/kmol


% 1B.2 - RP-1 COMBUSTION

% Complete oxidation:
% C12H26 + 18.5 O2 -> 12 CO2 + 13 H2O

[m_CO2_F9,m_O2_required_F9,m_H2O_F9] = combustion_RP1(m_RP1_F9,M_RP1, M_O2,M_CO2,M_H2O);

% Potential CO2 from all Falcon 9 Starlink missions
m_CO2_F9_total = N_F9_total*m_CO2_F9;


% 1B.3 - STARSHIP COMBUSTION

% Reuse the potential CO2 from Problem 1A
% for one complete Starship/Super Heavy system

m_CO2_starship_launch = m_CO2_total;

% Potential CO2 from Starship Starlink missions
m_CO2_starship_total = N_starship_total*m_CO2_starship_launch;


% 1B.4 - TOTAL STARLINK CO2

% Sum the contributions of both launch vehicle types
m_CO2_starlink = m_CO2_F9_total + m_CO2_starship_total;


% 1B.5 - ROAD TRANSPORT COMPARISON

% Petrol car emissions: 170 g CO2/km
emissions_car = 170/1000;  % kg/km

% Equivalent distance travelled by a petrol car
km_equivalent = m_CO2_starlink/emissions_car;


% 1B.6 - VERIFICATION

% Mass conservation for complete RP-1 oxidation
% Oxygen required is theoretical and may exceed
% the oxygen carried by Falcon 9.

error_RP1 = abs((m_RP1_F9 + m_O2_required_F9) - (m_CO2_F9 + m_H2O_F9));

% Actual reference mixture ratio
OF_F9 = m_LOX_F9/m_RP1_F9;

% Stoichiometric mixture ratio
OF_stoich = m_O2_required_F9/m_RP1_F9;


%% 1B.7 - RESULTS

fprintf('\n\n--- PROBLEM 1B: STARLINK CO2 EMISSIONS ---\n');

fprintf('\nNUMBER OF LAUNCHES\n');
fprintf('Falcon 9 launches = %d\n',N_F9_total);
fprintf('Starship launches = %d\n',N_starship_total);
fprintf('Total launches = %d\n', N_F9_total+N_starship_total);

fprintf('\nFALCON 9\n');
fprintf('Propellant per launch = %.2f tonnes\n',m_prop_F9/1000);
fprintf('RP-1 per launch = %.2f tonnes\n',m_RP1_F9/1000);
fprintf('Potential CO2 per launch = %.2f tonnes\n', m_CO2_F9/1000);
fprintf('Total Falcon 9 CO2 = %.2f tonnes\n', m_CO2_F9_total/1000);

fprintf('\nSTARSHIP\n');
fprintf('Potential CO2 per launch = %.2f tonnes\n', m_CO2_starship_launch/1000);
fprintf('Total Starship CO2 = %.2f tonnes\n',m_CO2_starship_total/1000);

fprintf('\nTOTAL STARLINK\n');
fprintf('Total potential CO2 = %.2f tonnes\n',m_CO2_starlink/1000);

fprintf('\nROAD TRANSPORT COMPARISON\n');
fprintf('Petrol car emissions = %.3f kg CO2/km\n',emissions_car);
fprintf('Equivalent distance = %.2f km\n',km_equivalent);
fprintf('Equivalent distance = %.2f million km\n', km_equivalent/1e6);

fprintf('\nVERIFICATION - RP1\n');
fprintf('Mass conservation error = %.3e kg\n', error_RP1);
fprintf('Reference Falcon 9 O/F = %.3f\n',OF_F9);
fprintf('Stoichiometric O/F = %.3f\n',OF_stoich);


% 1B.8 - YEARLY CO2 EMISSIONS GRAPH

% Potential CO2 produced each year
m_CO2_year = N_falcon9*m_CO2_F9 + N_starship*m_CO2_starship_launch;

figure;

bar(years,m_CO2_year/1e6);

xlabel('Year');
ylabel('Potential CO2 emissions [thousand tonnes]');
title('Estimated CO2 emissions from Starlink launches');

grid on;




