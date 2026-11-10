function Isp_value = Isp(T,mdot)
% T: thrust [N]
% mdot: mass flow rate [kg/s]
% Isp_value: specific impulse [s]
g0 = 9.80665; % m/s^2
Isp_value = T ./ (mdot .* g0);
end
