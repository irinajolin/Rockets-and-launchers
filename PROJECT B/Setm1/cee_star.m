function[Cstar] = cee_star(R0,T,gamma)
% Compute the dimensionless critical energy-exchange coefficient
% R0: universal gas constant
% T: temperature of the chamber (in Kelvin)
% gamma: adiabatic coefficient
gamma_big = sqrt(gamma) .* (2/(gamma + 1))^((gamma + 1)/2*(gamma - 1));
Cstar = sqrt(R0 .* T) ./ (gamma_big);
end