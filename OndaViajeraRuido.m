% =========================================================================
% ONDA ÚNICA DELIMITADA CON RUIDO GAUSSIANO, REBOTE Y RETORNO SIN INVERSIÓN
% =========================================================================

clear; clc; close all;

% 1. Parámetros físicos de la onda
A0 = 1.0;                 % Amplitud máxima
lambda = 2.0;             % Longitud de onda [m]
f = 1.0;                  % Frecuencia [Hz]

dospi = 2 * pi;           
w0 = dospi * f;           % Frecuencia angular [rad/s]
k0 = dospi / lambda;      % Número de onda [rad/m]
v = lambda * f;           % Velocidad de propagación [m/s]

% 2. Parámetros de la pared y de la envolvente gaussiana
x_wall = 6.0;             % Posición de la pared reflectante [m]
sigma_env = 0.4;          % Ancho espacial del pulso delimitado

% 3. Configuración del Ruido Gaussiano (Basado en Varianza)
% Nota: randn es el motor computacional equivalente a la distribución normal
% configurada en herramientas como randtool.
varianza_ruido = 0.04;              % Varianza del ruido (sigma^2)
sigma_ruido = sqrt(varianza_ruido); % Desviación estándar sigma

% 4. Discretización de los ejes espacial y temporal
M_space = 600;                        % Muestras espaciales
X_axis = linspace(0, 10, M_space);    % Eje espacial [m]

% Tiempo calculado para que la onda vaya, choque y regrese al inicio
C_tiempo = (2 * x_wall + 2) / v; 
M_tiempo = 250;                       % Fotogramas temporales (bucle for)
T_axis = linspace(0, C_tiempo, M_tiempo);

figure('Position', [100, 100, 900, 500], 'Color', 'w');

% 5. Bucle temporal para simular el avance, impacto y retorno
for n = 1:length(T_axis)
    t = T_axis(n);

    % --- A) ONDA DE IDA (Viaja de izquierda a derecha hacia la pared) ---
    x_center_emit = v * t; 
    env_emit = exp(-((X_axis - x_center_emit).^2) / (2 * sigma_env^2));
    carrier_emit = cos(w0 * t - k0 * X_axis);
    Y_emit = env_emit .* carrier_emit;
    Y_emit(X_axis > x_wall) = 0; % Se detiene en la pared

    % --- B) ONDA DE RETORNO (Regresa de derecha a izquierda SIN inversión vertical) ---
    % Calculamos la posición del eco regresando desde la pared
    x_center_refl = 2 * x_wall - v * t;
    env_refl = exp(-((X_axis - x_center_refl).^2) / (2 * sigma_env^2));

    % Mantenemos la portadora POSITIVA (sin el -1), por lo que no se invierte verticalmente
    carrier_refl = cos(w0 * t + k0 * X_axis - 2 * k0 * x_wall);
    Y_refl = env_refl .* carrier_refl;

    % El eco solo existe formalmente después de que ocurre el impacto en la pared
    Y_refl(X_axis > x_wall) = 0;
    if v * t < x_wall
        Y_refl(:) = 0; 
    end

    % --- C) ONDA IDEAL TOTAL Y ADICIÓN DE RUIDO GAUSSIANO ---
    Y_ideal = Y_emit + Y_refl;

    % Ruido gaussiano estocástico punto a punto en el espacio
    ruido = sigma_ruido * randn(size(X_axis));

    % Señal final con ruido superpuesto
    Y_ruidosa = Y_ideal + ruido;

    % =====================================================================
    % VISUALIZACIÓN GRÁFICA EN UNA SOLA VENTANA LIMPIA
    % =====================================================================
    cla; hold on;

    % Señal con ruido gaussiano (Lo que se mide)
    plot(X_axis, Y_ruidosa, 'Color', [0.2 0.4 0.8], 'LineWidth', 1.2);

    % Onda ideal limpia como referencia estructural
    plot(X_axis, Y_ideal, 'k--', 'LineWidth', 1.5);

    % Ubicación de la pared
    xline(x_wall, 'k:', 'LineWidth', 2);

    hold off;

    xlim([0 10]); ylim([-1.8 1.8]); grid on;
    title(['Onda Delimitada con Ruido Gaussiano (Varianza = ', num2str(varianza_ruido), ') | t = ', num2str(t, '%.2f'), ' s']);
    xlabel('Espacio (x) [m]');
    ylabel('Amplitud');
    legend('Señal con Ruido Gaussiano', 'Onda Ideal (Limpia)', 'Pared Fija', 'Location', 'northeast');

    drawnow;
end