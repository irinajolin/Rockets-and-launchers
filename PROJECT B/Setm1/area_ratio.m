function[Ar] = area_ratio(M,gamma)
% Find area ratio using Mach number and gamma
Ar = sqrt((1 ./ M^2) .* ((2 ./ (gamma + 1)) .* (1 + ((gamma - 1) / 2) .* M.^2)).^((gamma + 1)/(gamma - 1)));
end