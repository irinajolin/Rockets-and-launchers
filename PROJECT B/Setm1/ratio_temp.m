function [Tr,M] = ratio_temp ( Tr, M, gamma)
if isempty(Tr) && ~isempty(M) 
% tenim Match i gamma, calculem Tr 
    Tr=1 +((gamma-1)/2)*M.^2;
elseif isempty(M) && ~isempty(Tr)
    % tenim Tr i gamma --> calculem match
    M= sqrt (((Tr-1)*2)/(gamma-1));
end
