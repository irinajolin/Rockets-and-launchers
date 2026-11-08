function [epsilon, M] = area_ratio(epsilon,M,gamma)
if isempty(epsilon) && ~isempty(M)
    % tenim match i gamma  --> calculem epsilon
    epsilon = sqrt((1 ./ M^2) .* ((2 ./ (gamma + 1)) .* (1 + ((gamma - 1) / 2) .* M.^2)).^((gamma + 1)/(gamma - 1)));
elseif isempty (M) && ~isempty(epsilon)
    %tenim epsilon i gamma --> calculem match
    F= @(x) sqrt((1 ./ x^2) .* ((2 ./ (gamma + 1)) .* (1 + ((gamma - 1) / 2) .* x.^2)).^((gamma + 1)/(gamma - 1))) - epsilon;
    M0=3; % valor inicial 
    M= fsolve (F, M0);
end
