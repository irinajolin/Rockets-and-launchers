function [Tr,M] = ratio_temp ( Tr, M, gamma)
if isempty(Tr) && ~isempty(M) 
    Tr=1 +((gamma-1)/2)*M.^2;
elseif isempty(M) && ~isempty(Tr)
    M= sqrt (((Tr-1)*2)/(gamma-1));
end
