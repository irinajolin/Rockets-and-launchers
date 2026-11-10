function [At,Ae] = geometry[D_throat,epsilon]
At= pi*(D_throat /2)^2;
Ae= epsilon *At;
end
