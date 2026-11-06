
function [Isp] = Isp(T,mdot)
g0 = 9.80665;
Isp = T ./ (mdot .* g0);