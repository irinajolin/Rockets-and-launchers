function [epsilon,Pe,Pc,Pr_sup,Pr_sub] = area_ratio_press(epsilon,Pc, Pe, gamma)
if isempty(epsilon) && ~isempty(Pe) && ~isempty(Pc)
    % tenim gamma Pe, Pc  --> calculem epsilon
   epsilon = ((sqrt((gamma-1)/2))*(2/(gamma + 1))^((gamma+1)/(2*(gamma-1))))/(((Pe/Pc)^(1/gamma))*(sqrt(1-(Pe/Pc)^((gamma-1)/gamma))));
    elseif isempty (Pe) && ~isempty(epsilon) && ~isempty(Pc)
        % tenim gamma, epsilon i Pc --> calculem Pe
        F1= @(x)((sqrt((gamma-1)/2))*(2/(gamma + 1))^((gamma+1)/(2*(gamma-1))))/(((x/Pc)^(1/gamma))*(sqrt(1-(x/Pc)^((gamma-1)/gamma))))-epsilon;
        Pe0=0.00001;
        Pe = fsolve (F1,Pe0);
    elseif isempty (Pc) && ~isempty(epsilon) && ~isempty(Pe)
        %tenim gamma, epsilon i pe, volem, pc
         F2= @(x)((sqrt((gamma-1)/2))*(2/(gamma + 1))^((gamma+1)/(2*(gamma-1))))/(((Pe/x)^(1/gamma))*(sqrt(1-(Pe/x)^((gamma-1)/gamma))))-epsilon;
         Pe02=0.00001;
         Pc = fsolve (F2,Pe02);
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
