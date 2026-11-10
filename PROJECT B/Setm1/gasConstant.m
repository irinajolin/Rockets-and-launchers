function Rs = gasConstant(molar)
% Rs: specific gas constant [J/(kg K)]
R0 = 8.31446261815324; % Universal gas constant [J/(mol K)]
Rs = R0 ./ molar;
end
