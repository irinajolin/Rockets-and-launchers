% Rockets and launcher; UPC, EETAC
% Orbital simulator
% WP2: Flight profile and integration
% 08/10/2026

function interactive_pitch_simulation()
    % --- CONFIGURACIÓN DE LA FIGURA INTERACTIVA ---
    fig = figure('Name', 'Simulador de Pitch Schedule - Cohetes', 'NumberTitle', 'off', 'Position', [100, 100, 1100, 700]);

    % Panel de control para el Slider
    pnl = uipanel(fig, 'Position', [0.02, 0.02, 0.96, 0.12], 'Title', 'Control de Pitch Schedule');
    
    uilabel(pnl, 'Position', [20, 25, 200, 22], 'Text', 'Inicio del Giro t_turn (s):', 'FontWeight', 'bold');
        
    slider = uislider(pnl, 'Position', [220, 35, 600, 3],'Limits', [5, 60], 'Value', 20, 'ValueChangedFcn', @(src, event) updatePlots(src.Value));

    lblVal = uilabel(pnl, 'Position', [840, 25, 100, 22], 'Text', '20.0 s', 'FontWeight', 'bold');

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
    mdry = 12000;         % Masa en vacío (después de quemar todo el combustible)
    tb = 200;             % Tiempo de quemado [s]
    m_dot = (m0 - mdry) / tb;          % Flujo másico [kg/s]
    Isp = 280;            % Impulso específico [s]
    Thrust = m_dot * g0 * Isp; % Empuje [N]
    S = 7.0;              % Área de referencia [m^2]
    Cd = 0.3;             % Coeficiente de arrastre
    rho0 = 1.225;         % Densidad del aire a nivel del mar [kg/m^3]
    H_atm = 7500;         % Escala de altura atmosférica [m]

    % Condiciones iniciales: [h, x, V, gamma, m]
    tmax = 1200; % we put a maximum time of 20 minutes to visualize the
    % reentry of the launcher
    dt = 0.05;
    t = 0:dt:tmax;
    
    N = length(t);
    h = zeros(1, N); % altitude
    x = zeros(1, N); % position in x axis
    V = zeros(1, N); % velocity
    gamma = zeros(1, N); % flight path angle
    m = zeros(1, N); 
    psi = zeros(1, N); % pitch angle
    Q = zeros(1, N); % dynamic atmospheric pressure forces
    Vt = zeros(1, N); % transversal velocity

    % initial conditions: h=0m, x=0m, V=0.1m/s, gamma=89.9 deg, m=m0
    hi = 0; xi = 0; Vi = 1.0; gi = deg2rad(89.9); mi = m0;
    for i = 1:N
        ti = t(i);
        
        % Thrust before and after motor cutpff
        if ti <= tb
            T = Thrust;
            mi = m0 - m_dot * ti;
        else 
            T = 0; % motor off, no thust anymore
            mi = mdry; % all propellant consumed
        end

        % Definición del Pitch Schedule theta(t)
        if ti < t_turn
            ps = deg2rad(89.9); % Vertical hold
        elseif ti < (t_turn + 80)
            % Pitchover / maniobra de giro
            ps = deg2rad(89.9) - deg2rad(65) * ((ti - t_turn)/80);
        else
            ps = deg2rad(24.9); % Shallower pitch hold
        end
       
        % Atmósfera exponencial
        rho = rho0 * exp(-max(0, hi)/H_atm);
        Qi = 0.5 * rho * Vi^2;
        D = Qi * S * Cd;
        
        % Ángulo de ataque alpha
        alpha = ps - gi;
        
        % Ecuaciones diferenciales de movimiento (Forward Euler)
        r = Re + hi;
        g = g0 * (Re / r)^2;
        
        dVdt = (T * cos(alpha) - D) / mi - g * sin(gi);
        
        if Vi > 5
            dgdt = (T * sin(alpha)) / (mi * Vi) - (g / Vi - Vi / r) * cos(gi);
        else
            dgdt = 0; % keep stable at low velocities
        end 

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
        hi = hi + dhdt * dt;
        xi = xi + dxdt * dt;
        Vi = max(0.1, Vi + dVdt * dt);
        gi = gi + dgdt * dt;
        mi = max(mi - m_dot * dt, 1000);
        
        if hi < 0 % Detener si impacta el suelo
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
