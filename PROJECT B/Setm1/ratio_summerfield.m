function [Pe_limit] = ratio_summerfield(Pe,Pa)

% Summerfield criterion: Pe/Pa >= 0.4

Pe_limit = 0.4 .* Pa;

if ~isempty(Pe)

    if Pe/Pa >= 0.4
        disp('Summerfield criterion satisfied: attached flow expected.');
    else
        disp('Summerfield criterion not satisfied: flow separation may occur.');
    end

end

end
