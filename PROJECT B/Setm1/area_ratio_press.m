function [epsilon,Pr_sup,Pr_sub] = area_ratio_press(epsilon,Pc, Pe, gamma)
%Pe/Pc 
if isempty(epsilon) && ~isempty(Pe) && ~isempty(Pc)
    % tenim gamma Pe, Pc  --> calculem epsilon
   epsilon = ((sqrt((gamma-1)/2))*(2/(gamma + 1))^((gamma+1)/(2*(gamma-1))))/(((Pe/Pc)^(1/gamma))*(sqrt(1-(Pe/Pc)^((gamma-1)/gamma))));
 
    elseif isempty (Pc) && ~isempty(epsilon) && isempty(Pe) 
        % no tenim ni pe ni pc pero calculem el ratio 
        F3= @(x)((sqrt((gamma-1)/2))*(2/(gamma + 1))^((gamma+1)/(2*(gamma-1))))/(((x)^(1/gamma))*(sqrt(1-(x)^((gamma-1)/gamma))))-epsilon;
        % Solucio supersonica
        Pr0_sup = 0.01;
        Pr_sup = fsolve(F3, Pr0_sup);
        % Solucio subsonica
        Pr0_sub = 0.99;
        Pr_sub = fsolve(F3, Pr0_sub);
            
end
