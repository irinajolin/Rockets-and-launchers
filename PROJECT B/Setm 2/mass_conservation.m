
function [error_prop,error_comb] = mass_conservation(m_prop,m_CH4,m_O2,m_CO2,M_CH4,M_CO2,M_CO,M_H2O)

% 1. Verify propellant mass conservation
error_prop = abs(m_prop - (m_CH4 + m_O2));

% 2. Calculate kmol of methane and CO2
n_CH4 = m_CH4 / M_CH4;
n_CO2 = m_CO2 / M_CO2;

% 3. Calculate kmol of CO and H2O
% CH4 + a O2 -> b CO2 + (1-b) CO + 2 H2O
n_CO = n_CH4 - n_CO2;
n_H2O = 2*n_CH4;

% 4. Calculate masses of CO and H2O
m_CO = n_CO * M_CO;
m_H2O = n_H2O * M_H2O;

% 5. Calculate reactants and products masses
m_reactants = m_CH4 + m_O2;
m_products = m_CO2 + m_CO + m_H2O;

% 6. Relative mass conservation error
error_comb = abs(m_reactants-m_products)/m_reactants;

end
