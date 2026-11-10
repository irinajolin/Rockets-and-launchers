function [cp,cv] = gasProperties(Rs,gamma)
% Specific heat capacities [J/(kg K)] for a perfect gas.
cp = gamma*Rs/(gamma-1);
cv = Rs/(gamma-1);
end
