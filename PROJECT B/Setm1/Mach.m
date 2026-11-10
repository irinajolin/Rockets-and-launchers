% Rockets and Launchers. Part B 
% 05/11/2026
function [a,M]= Mach(gamma,Rs,T,v)
% gamma: adiabatic coefficient
% R0: universal gas constant
% T: temperature (in Kelvin)
% Calculate the speed of sound and corresponding Mach number
% v: exhaust velocity
a = sqrt(gamma * Rs * T);
M = v/a;
