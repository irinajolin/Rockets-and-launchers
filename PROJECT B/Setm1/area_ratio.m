function [Ar, M] = area_ratio(Ar,M,gamma)
if isempty(epsilon) && ~isempty(M)
    % tenim match i gamma  --> calculem epsilon
    Ar = sqrt((1 ./ M^2) .* ((2 ./ (gamma + 1)) .* (1 + ((gamma - 1) / 2) .* M.^2)).^((gamma + 1)/(gamma - 1)));
elseif isempty (M) && ~isempty(Ar)
    %tenim Ar i gamma --> calculem match
    F= @(x) sqrt((1 ./ x^2) .* ((2 ./ (gamma + 1)) .* (1 + ((gamma - 1) / 2) .* x.^2)).^((gamma + 1)/(gamma - 1))) - epsilon;
    M0=2;
    M= fsolve (F, M0);
end
