% Rockets and Launchers. Part B 
% 05/11/2026
function [a,M,Rs] = Mach(gamma,R0,molar,T,v)
% gamma: adiabatic coefficient
% R0: universal gas constant
% T: temperature (in Kelvin)
% Calculate the speed of sound and corresponding Mach number
% v: exhaust velocity
Rs = R0/molar;
a = sqrt(gamma * Rs * T);
M = v/a;
