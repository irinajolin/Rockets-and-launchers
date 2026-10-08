% Rockets and launcher; UPC, EETAC
% Orbital simulator
% WP2: Flight profile and integration
% 08/10/2026

function interactive_pitch_simulation()
    % --- CONFIGURACIÓN DE LA FIGURA INTERACTIVA ---
    fig = figure('Name', 'Simulador de Pitch Schedule - Cohetes', ...
                 'NumberTitle', 'off', 'Position', [100, 100, 1100, 700]);

    % Panel de control para el Slider
    pnl = uipanel(fig, 'Position', [0.02, 0.02, 0.96, 0.12], 'Title', 'Control de Pitch Schedule');
    
    uilabel(pnl, 'Position', [20, 25, 200, 22], ...
            'Text', 'Inicio del Giro t_turn (s):', 'FontWeight', 'bold');
        
    slider = uislider(pnl, 'Position', [220, 35, 600, 3], ...
                      'Limits', [5, 60], 'Value', 20, ...
                      'ValueChangedFcn', @(src, event) updatePlots(src.Value));

    lblVal = uilabel(pnl, 'Position', [840, 25, 100, 22], ...
                     'Text', '20.0 s', 'FontWeight', 'bold');

    % Crear subplots
    ax1 = subplot(2, 2, 1, 'Parent', fig); grid(ax1, 'on'); hold(ax1, 'on');
    title(ax1, 'Trayectoria (Altitud vs Downrange)'); xlabel(ax1, 'Downrange [km]'); ylabel(ax1, 'Altitud [km]');

    ax2 = subplot(2, 2, 2, 'Parent', fig); grid(ax2, 'on'); hold(ax2, 'on');
    title(ax2, 'Presión Dinámica (Q)'); xlabel(ax2, 'Tiempo [s]'); ylabel(ax2, 'Q [kPa]');

    ax3 = subplot(2, 2, 3, 'Parent', fig); grid(ax3, 'on'); hold(ax3, 'on');
    title(ax3, 'Ángulos \psi (Pitch) y \gamma (Flight Path)'); xlabel(ax3, 'Tiempo [s]'); ylabel(ax3, 'Ángulo [deg]');

    ax4 = subplot(2, 2, 4, 'Parent', fig); grid(ax4, 'on'); hold(ax4, 'on');
    title(ax4, 'Velocidad Transversal (V_t)'); xlabel(ax4, 'Tiempo [s]'); ylabel(ax4, 'V_t [m/s]');

    % Ejecución inicial
    updatePlots(slider.Value);

    % --- FUNCIÓN DE ACTUALIZACIÓN ---
    function updatePlots(t_turn)
        lblVal.Text = sprintf('%.1f s', t_turn);
        
        % Ejecutar simulación
        data = run_simulation(t_turn);
        
        % Limpiar gráficas
        cla(ax1); cla(ax2); cla(ax3); cla(ax4);
        
        % 1. Trayectoria
        plot(ax1, data.downrange / 1000, data.h / 1000, 'b-', 'LineWidth', 2);
        
        % 2. Presión Dinámica
        plot(ax2, data.t, data.Q / 1000, 'r-', 'LineWidth', 2);
        
        % 3. Ángulos phi y gamma
        plot(ax3, data.t, rad2deg(data.psi), 'k--', 'LineWidth', 1.5, 'DisplayName', '\psi (Pitch)');
        plot(ax3, data.t, rad2deg(data.gamma), 'g-', 'LineWidth', 2, 'DisplayName', '\gamma (Flight path)');
        legend(ax3, 'Location', 'northeast');
        
        % 4. Velocidad Transversal
        plot(ax4, data.t, data.Vt, 'm-', 'LineWidth', 2);
    end
end

% --- MODELO DE SIMULACIÓN INTEGRADOR ---
function sim = run_simulation(t_turn)
    % Constantes físicas y del vehículo
    g0 = 9.81;            % m/s^2
    Re = 6371e3;          % Radio terrestre [m]
    m0 = 100000;          % Masa inicial [kg]
    m_dot = 350;          % Flujo másico [kg/s]
    Isp = 280;            % Impulso específico [s]
    Thrust = m_dot * g0 * Isp; % Empuje [N]
    tb = 200;             % Tiempo de quemado [s]
    S = 7.0;              % Área de referencia [m^2]
    Cd = 0.3;             % Coeficiente de arrastre
    rho0 = 1.225;         % Densidad del aire a nivel del mar [kg/m^3]
    H_atm = 7500;         % Escala de altura atmosférica [m]

    % Condiciones iniciales: [h, x, V, gamma, m]
    y0 = [10; 0; 10; deg2rad(89.9); m0]; 
    dt = 0.2;
    t = 0:dt:tb;
    
    N = length(t);
    h = zeros(1, N); % altitude
    x = zeros(1, N); % position in x axis
    V = zeros(1, N); % velocity
    gamma = zeros(1, N); % flight path angle
    m = zeros(1, N); 
    psi = zeros(1, N); % pitch angle
    Q = zeros(1, N); 
    Vt = zeros(1, N);

    y = y0;
    
    for i = 1:N
        ti = t(i);
        
        % Definición del Pitch Schedule theta(t)
        if ti < t_turn
            ps = deg2rad(90); % Vertical hold
        elseif ti < (t_turn + 40)
            % Pitchover / maniobra de giro
            ps = deg2rad(90) - deg2rad(70) * ((ti - t_turn)/40);
        else
            ps = deg2rad(20); % Shallower pitch hold
        end
        
        % Estado actual
        hi = y(1); 
        xi = y(2); 
        Vi = y(3); 
        gi = y(4); 
        mi = y(5);
        
        % Atmósfera exponencial
        rho = rho0 * exp(-max(0, hi)/H_atm);
        Qi = 0.5 * rho * Vi^2;
        D = Qi * S * Cd;
        
        % Ángulo de ataque alpha
        alpha = ps - gi;
        
        % Ecuaciones diferenciales de movimiento (Forward Euler)
        r = Re + hi;
        g = g0 * (Re / r)^2;
        
        dVdt = (Thrust * cos(alpha) - D) / mi - g * sin(gi);
        dgdt = (Thrust * sin(alpha)) / (mi * Vi) - (g / Vi - Vi / r) * cos(gi);
        dhdt = Vi * sin(gi);
        dxdt = Vi * cos(gi) * (Re / r);
        
        % Guardar variables
        h(i) = hi; 
        x(i) = xi; 
        V(i) = Vi; 
        gamma(i) = gi; 
        m(i) = mi; 
        psi(i) = ps; 
        Q(i) = Qi; 
        Vt(i) = Vi * cos(gi);
        
        % Integración para el siguiente paso
        y(1) = hi + dhdt * dt;
        y(2) = xi + dxdt * dt;
        y(3) = max(0.1, Vi + dVdt * dt);
        y(4) = gi + dgdt * dt;
        y(5) = max(mi - m_dot * dt, 1000);
        
        if y(1) < 0 % Detener si impacta el suelo
            break;
        end
    end

    % Guardar resultados en estructura
    sim.t = t(1:i); 
    sim.h = h(1:i); 
    sim.downrange = x(1:i);
    sim.V = V(1:i); 
    sim.gamma = gamma(1:i); 
    sim.psi = psi(1:i);
    sim.Q = Q(1:i); 
    sim.Vt = Vt(1:i);
end