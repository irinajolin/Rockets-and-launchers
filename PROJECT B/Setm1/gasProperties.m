function [cp,cv] = gasProperties(Rs,gamma)
% Specific heat capacities [J/(kg K)] for a perfect gas.
validateattributes(gamma,{'numeric'},{'real','scalar','>',1});
cp = gamma*Rs/(gamma-1);
cv = Rs/(gamma-1);
end
