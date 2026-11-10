
function [T1]=T_Mach(T0,M1,gamma)
T1 = T0 ./ (1 + ((gamma - 1) / 2)) .* M1^2; 


