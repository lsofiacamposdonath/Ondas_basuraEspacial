% -----------------------------------------------------------------
% MODELADO TEÓRICO CON TIEMPO DINÁMICO DE PROPAGACIÓN Y REFLEXIÓN
% -----------------------------------------------------------------

% 1. Parámetros teóricos de la onda
w0 = 1;                   % Frecuencia angular w0 = 1 rad/s
f0 = w0 / (2 * pi);       % Frecuencia f0 = 1/(2*pi) Hz
T0 = 1 / f0;              % Periodo temporal T0 = 2*pi s

R0 = 2;                   % Frecuencia espacial (ciclos/m)
lambda0 = 1 / R0;         % Longitud de onda lambda0 = 0.5 m
k0 = 2 * pi * R0;         % Número de onda k0 = 4*pi rad/m

v = w0 / k0;              % Velocidad de fase v = 1/(4*pi) m/s (~0.0796 m/s)
phi0 = 0;                 % Desfase inicial

% 2. Parámetros del Pulso y Obstáculo
tau = 1.0;                % Ancho de la ventana pulso h(t)
x_wall = 2.5;             % Posición de la pared sólida

% 3. Discretización de ejes (Tiempo calculado dinámicamente)
M_space = 512;            % Número de muestras espaciales M_space
C_space = 4;              % Rango total del eje espacial
X_axis = linspace(0, C_space, M_space);

% TIEMPO CORREGIDO: Tiempo necesario para que la onda vaya a x_wall y regrese
C_tiempo = (2 * x_wall + tau) / v; % C_tiempo se calcula en segundos
M_tiempo = 300;                    % Cantidad de muestras temporales
T_axis = linspace(0, C_tiempo, M_tiempo);

figure('Position', [100, 100, 850, 650]);

for n = 1:length(T_axis)
    t = T_axis(n);

    % --- 1. ENVOLVENTE EMITIDA h_emit(x,t) ---
    x_front_emit = v * t;
    x_back_emit  = x_front_emit - tau;
    h_emit = (X_axis >= x_back_emit) & (X_axis <= x_front_emit) & (X_axis <= x_wall);

    % --- 2. ENVOLVENTE REFLEJADA h_refl(x,t) ---
    % Comienza a salir de x_wall hacia la izquierda a partir del impacto
    x_front_refl = 2 * x_wall - v * t;
    x_back_refl  = x_front_refl + tau;
    h_refl = (X_axis >= x_front_refl) & (X_axis <= x_back_refl) & (X_axis <= x_wall) & (X_axis >= 0);

    % --- 3. PORTADORAS Y MODULACIÓN DE SEÑAL ---
    carrier_emit = cos(w0 * t - k0 * X_axis + phi0);

    % Inversión -1*h(t) en la amplitud por choque en extremo fijo
    carrier_refl = -1 * cos(w0 * t + k0 * X_axis - 2 * k0 * x_wall + phi0);

    Y_emit = h_emit .* carrier_emit;
    Y_refl = h_refl .* carrier_refl;

    % --- PANEL 1: VENTANA PULSO h(x,t) ---
    subplot(2, 1, 1);
    cla; hold on;
    plot(X_axis, h_emit, 'b-', 'LineWidth', 2);
    plot(X_axis, h_refl, 'r--', 'LineWidth', 2);
    xline(x_wall, 'k:', 'LineWidth', 1.5);
    hold off;

    xlim([0 C_space]); ylim([-0.2 1.3]); grid on;
    title(['Ventana Pulso h(x,t) | M\_space = ', num2str(M_space)]);
    ylabel('Envolvente h(t)');
    legend('Pulso Emitido', 'Eco Reflejado', 'Obstáculo');

    % --- PANEL 2: ONDA DISCRETIZADA Y REFLEJADA ---
    subplot(2, 1, 2);
    cla; hold on;
    plot(X_axis, Y_emit, 'b-', 'LineWidth', 1.8);
    plot(X_axis, Y_refl, 'r--', 'LineWidth', 1.8);
    xline(x_wall, 'k:', 'LineWidth', 1.5);
    hold off;

    xlim([0 C_space]); ylim([-1.4 1.4]); grid on;
    title(['Onda Modulada | t = ', num2str(t, '%.2f'), ' s de ', num2str(C_tiempo, '%.1f'), ' s']);
    xlabel('Espacio (X\_axis)');
    ylabel('Amplitud Modulada');
    legend('Portadora Emitida', 'Eco Reflejado (-1 \cdot h(t))');

    drawnow;
end