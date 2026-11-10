function [mass_flow] = mdot(pc,At,Cstar,rho,A,v)

% Compute mass flow rate
% pc: chamber pressure [Pa]
% At: throat area [m^2]
% Cstar: characteristic velocity [m/s]
% rho: gas density [kg/m^3]
% A: local nozzle area [m^2]
% v: local gas velocity [m/s]

if ~isempty(pc) && ~isempty(At) && ~isempty(Cstar)
    % Mass flow using characteristic velocity
    mass_flow = (pc .* At) ./ Cstar;

elseif ~isempty(rho) && ~isempty(A) && ~isempty(v)
    % Mass flow using mass conservation
    mass_flow = rho .* A .* v;


end

end
