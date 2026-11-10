function [Isp] = Isp(T,mdot)
% T: thrust [N]
% mdot: mass flow rate [kg/s]
% Isp_value: specific impulse [s]
g0 = 9.80665; % m/s^2
Isp = T ./ (mdot .* g0);
end
