function [rho_r, M]= density_ratio (M,rho_r,gamma)
if isempty(rho) && ~isempty(M)
    rho_r = (1 +((gamma-1)/2).*M.^2).^((1)/(gamma-1));
elseif isempty(M) && ~isempty(rho_r)
    M = sqrt((rho_r.^((gamma-1)/1) - 1) .* 2 ./ (gamma-1));
end
