
function [m_CO2,m_O2_required,m_H2O] = combustion_RP1(m_RP1,M_RP1,M_O2,M_CO2,M_H2O)

% Complete oxidation of RP-1, represented as C12H26
% C12H26 + 18.5 O2 -> 12 CO2 + 13 H2O

% Step 1: Calculate kmol of RP-1
n_RP1 = m_RP1 / M_RP1;

% Step 2: Calculate product kmol
n_CO2 = 12*n_RP1;
n_H2O = 13*n_RP1;

% Step 3: Oxygen needed for complete combustion
n_O2_required = 18.5*n_RP1;

% Step 4: Convert kmol into kg
m_CO2 = n_CO2*M_CO2;
m_H2O = n_H2O*M_H2O;
m_O2_required = n_O2_required*M_O2;

end
