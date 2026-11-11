function [T, T_momentum, T_pressure] = thrust(mdot, Ve, Ae, Pe, Pa)
%Nina Cid
%Exit velocity function from 1-Rockets-Ideal rocket engine.key page 47
% Inputs:
% Ae exit area
% Pa atmospheric pressure
% Pe exit pressure
% Ve exit velocity
% mdot
T_momentum = mdot*Ve;
T_pressure = Ae.*(Pe - Pa);
T = T_momentum + T_pressure;
end
