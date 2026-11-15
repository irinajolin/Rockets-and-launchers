function [m_CO2, m_CO2_total]= combustion_methane (m_CH4, m_O2, M_CH4, M_O2, M_CO2)
% Step 1: Calculate kmol of methane and oxygen
n_CH4 = m_CH4 / M_CH4;
n_O2 = m_O2 / M_O2;

% Step 2: Oxygen coefficient per mole of methane
a = n_O2 / n_CH4;

% Step 3: Calculate the fraction of carbon forming CO2
% CH4 + a O2 -> b CO2 + (1-b) CO + 2 H2O
b = 2*a - 3;

% Check that the simplified reaction is valid
if b < 0 || b > 1
    error('This combustion model requires 1.5 <= a <= 2.');
end

% Step 4: CO2 produced directly
n_CO2 = b * n_CH4;
m_CO2 = n_CO2 * M_CO2;

% Step 5: CO2 if all CO is later oxidized
m_CO2_total = n_CH4 * M_CO2;
end
