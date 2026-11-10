function [] = ratio_summerfield(Pe,Pa)
if Pe/Pa >= 0.4
    disp('Summerfield criterion satisfied: attached flow expected.');
else
    disp('Summerfield criterion not satisfied: flow separation may occur.');
end
end
