function Cstar = characteristicVelocity(Rs,Tc,gamma)
% Characteristic velocity C* [m/s], choked isentropic throat.
Gamma = sqrt(gamma)*(2/(gamma+1))^((gamma+1)/(2*(gamma-1)));
Cstar = sqrt(Rs*Tc)/Gamma;
end
