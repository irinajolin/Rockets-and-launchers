% Rockets and Launchers. Part B
% 05/11/2026

function [a,M,v] = Mach(gamma,Rs,T,v,M)

% gamma: adiabatic coefficient
% Rs: specific gas constant [J/(kg*K)]
% T: local temperature [K]
% v: gas velocity [m/s]
% M: Mach number

% Speed of sound
a = sqrt(gamma .* Rs .* T);

if isempty(M) && ~isempty(v)
    % Tenim velocitat i calculem Mach
    M = v ./ a;

elseif isempty(v) && ~isempty(M)
    % Tenim Mach i calculem velocitat
    v = M .* a;

else
    error('Introdueix M o v com a incognita utilitzant [].');
end

end
