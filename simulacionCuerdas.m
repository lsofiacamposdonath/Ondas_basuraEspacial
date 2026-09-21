% -----------------------------------------------------------------
% SIMULACIÓN EXACTA: 4 CUERDAS PARALELAS CON PULSO Y PORTADORA REFLEJADA
% -----------------------------------------------------------------

% 1. Parámetros teóricos de la onda 
w0 = 1;                   % Frecuencia angular w0 = 1 rad/s
R0 = 2;                   % Frecuencia espacial (2 ciclos/m)
k0 = 2 * pi * R0;         % Número de onda k0 = 4*pi rad/m
v = w0 / k0;              % Velocidad de fase v = 1/(4*pi) m/s
phi0 = 0;                 % Desfase inicial
tau = 1.0;                % Ancho de la ventana pulso h(t)

% 2. Configuración de Puntos Fijos (Paredes) y Desplazamiento
x_walls = [2.0, 3.0, 4.0, 5.0]; 
num_cuerdas = length(x_walls);
y_offsets = [4.5, 3.0, 1.5, 0.0]; % Desplazamiento vertical en el plano Y

% 3. Discretización de ejes (M_space y M_tiempo)
M_space = 512;
C_space = 6.0;
X_axis = linspace(0, C_space, M_space);

max_wall = max(x_walls);
C_tiempo = (2 * max_wall + tau) / v; 
M_tiempo = 350;
T_axis = linspace(0, C_tiempo, M_tiempo);

figure('Position', [100, 50, 950, 750]);

for n = 1:length(T_axis)
    t = T_axis(n);
    
    % --- PANEL 1: VENTANA PULSO RECTANGULAR h(x,t) EN LAS 4 CUERDAS ---
    subplot(2, 1, 1);
    cla; hold on;
    
    for i = 1:num_cuerdas
        xw = x_walls(i);
        off = y_offsets(i);
        
        % Pulso Emitido h_emit(x,t)
        x_front_emit = v * t;
        x_back_emit  = x_front_emit - tau;
        h_emit = (X_axis >= x_back_emit) & (X_axis <= x_front_emit) & (X_axis <= xw);
        
        % Eco Reflejado h_refl(x,t)
        x_front_refl = 2 * xw - v * t;
        x_back_refl  = x_front_refl + tau;
        h_refl = (X_axis >= x_front_refl) & (X_axis <= x_back_refl) & ...
                 (X_axis <= xw) & (X_axis >= 0);
             
        % Graficado de Envolventes h(t)
        line([0 C_space], [off off], 'Color', [0.85 0.85 0.85], 'LineStyle', '--');
        plot(X_axis, h_emit + off, 'b-', 'LineWidth', 1.8);
        plot(X_axis, h_refl + off, 'r--', 'LineWidth', 1.8);
        xline(xw, 'k:', 'LineWidth', 1.2);
    end
    
    hold off;
    xlim([0 C_space]); ylim([-0.5 max(y_offsets) + 2.0]); grid on;
    title(['Ventanas Pulso h(x,t) | M\_space = ', num2str(M_space), ' | t = ', num2str(t, '%.2f'), ' s']);
    ylabel('Envolventes h(t) + Offset');
    legend('Pulso Emitido', 'Eco Reflejado', 'Obstáculo / Pared');

    % --- PANEL 2: PORTADORAS MODULADAS CON INVERSIÓN -1*h(t) ---
    subplot(2, 1, 2);
    cla; hold on;
    
    for i = 1:num_cuerdas
        xw = x_walls(i);
        off = y_offsets(i);
        
        % Envolventes
        x_front_emit = v * t;
        x_back_emit  = x_front_emit - tau;
        h_emit = (X_axis >= x_back_emit) & (X_axis <= x_front_emit) & (X_axis <= xw);
        
        x_front_refl = 2 * xw - v * t;
        x_back_refl  = x_front_refl + tau;
        h_refl = (X_axis >= x_front_refl) & (X_axis <= x_back_refl) & ...
                 (X_axis <= xw) & (X_axis >= 0);
             
        % Portadora Emitida
        carrier_emit = cos(w0 * t - k0 * X_axis + phi0);
        Y_emit = h_emit .* carrier_emit;
        
        % Portadora Reflejada con Inversión de Signo -1*h(t)
        carrier_refl = -1 * cos(w0 * t + k0 * X_axis - 2 * k0 * xw + phi0);
        Y_refl = h_refl .* carrier_refl;
        
        % Graficado de Ondas Moduladas (Azul = Emitida, Roja Punteada = Reflejada)
        line([0 C_space], [off off], 'Color', [0.85 0.85 0.85], 'LineStyle', '--');
        plot(X_axis, Y_emit + off, 'b-', 'LineWidth', 1.8);
        plot(X_axis, Y_refl + off, 'r--', 'LineWidth', 1.8);
        xline(xw, 'k:', 'LineWidth', 1.2);
    end
    
    hold off;
    xlim([0 C_space]); ylim([-1.5 max(y_offsets) + 2.0]); grid on;
    title(['Ondas Moduladas (-1 \cdot h(t) aplicado al signo) | t = ', num2str(t, '%.2f'), ' s de ', num2str(C_tiempo, '%.1f'), ' s']);
    xlabel('Espacio (X\_axis) [m]');
    ylabel('Amplitud Modulada + Offset');
    legend('Portadora Emitida', 'Eco Reflejado (-1 \cdot h(t))', 'Obstáculo / Pared');
    
    drawnow;
end