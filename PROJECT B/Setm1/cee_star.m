function[Rs,Cstar] = cee_star(R0,molar,T,gamma)
% Compute the dimensionless critical energy-exchange coefficient
% R0: universal gas constant
% molar: Molar mass
% T: temperature of the chamber (in Kelvin)
% gamma: adiabatic coefficient
Rs = R0/molar; % specific gas constant [m/s] 
gamma_big = sqrt(gamma) .* (2/(gamma + 1))^((gamma + 1)/2*(gamma - 1));
Cstar = sqrt(Rs .* T) ./ (gamma_big);
end
