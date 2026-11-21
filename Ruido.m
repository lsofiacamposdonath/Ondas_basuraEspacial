% Parámetros de la onda
A = 1;          % Amplitud
lambda = 2;     % Longitud de onda
f = 1;          % Frecuencia
v = lambda * f; % Velocidad de propagación
phi0 = 0;       % Constante de desfase inicial (en radianes)

% Ejes espacial y temporal
x = linspace(0, 10, 500); % Posición
t = linspace(0, 10, 500);   % Tiempo

% Número de onda (k) y frecuencia angular (omega)
k = 2 * pi / lambda;
omega = 2 * pi * f;

% Parámetro de control del ruido gaussiano
sigma_ruido = 0.25; % Desviación estándar del ruido (intensidad del ruido)

% Bucle de animación con ruido en el espacio y el tiempo
figure('Position', [100, 100, 800, 500]);
for n = 1:length(t)
    % 1. Ecuación de la onda viajera ideal (sentido derecho: x - v*t)
    y_ideal = A * sin(k * x - omega * t(n) + phi0);

    % 2. Generación de ruido gaussiano en espacio y tiempo
    % randn genera valores aleatorios con distribución gaussiana
    ruido = sigma_ruido * randn(size(x));

    % 3. Señal resultante (Onda + Ruido espacio-temporal)
    y_ruidosa = y_ideal + ruido;

    % Gráfica de la señal con ruido y comparación opcional con la ideal
    plot(x, y_ruidosa, 'Color', [0.2 0.4 0.8], 'LineWidth', 1.5);
    hold on;
    plot(x, y_ideal, 'r--', 'LineWidth', 1); % Onda limpia de referencia
    hold off;

    ylim([-A * 1.8, A * 1.8]);
    grid on;
    title(['Onda Viajera con Ruido Gaussiano en t = ', num2str(t(n), '%.2f'), ' s']);
    xlabel('Posición (x)');
    ylabel('Amplitud (y)');
    legend('Onda con Ruido', 'Onda Ideal', 'Location', 'northeast');
    drawnow;
end