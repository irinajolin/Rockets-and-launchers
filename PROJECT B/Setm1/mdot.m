function[mdot] = mdot(pc,At,Cstar)
% Compute mass flow rate 
% pc: pressure of the chamber
% At: area of the throat
% Cstar: critical energy-exchange coefficient
mdot = (pc .* At) ./ Cstar; % mass flow rate [kg/s]
end