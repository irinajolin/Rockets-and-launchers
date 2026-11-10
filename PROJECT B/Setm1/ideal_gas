function [rho,P,T,V,m] = ideal_gas(rho,Rs,P,T,V,m)

    if isempty(rho)
        % Calculem la densitat
        if ~isempty(P) && ~isempty(T)
            rho = P ./ (Rs .* T);

        elseif ~isempty(m) && ~isempty(V)
            rho = m ./ V;
        end

    elseif isempty(P)
        % Calculem pressio
        P = rho .* Rs .* T;

    elseif isempty(T)
        % Calculem temperatura
        T = P ./ (rho .* Rs);

    elseif isempty(V)
        % Calculem volum
        V = m ./ rho;

    elseif isempty(m)
        % Calculem massa
        m = rho .* V;
    end

end
