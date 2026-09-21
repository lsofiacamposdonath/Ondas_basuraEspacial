% Parámetros de la onda
A = 1;          % Amplitud
lambda = 2;     % Longitud de onda
f = 1;          % Frecuencia
v = lambda * f; % Velocidad de propagación
phi0 = 0;       % Constante de desfase inicial (en radianes)

% Ejes espacial y temporal
x = linspace(0, 10, 500); % Posición
t = linspace(0, 5, 200);   % Tiempo

% Número de onda (k) y frecuencia angular (omega)
k = 2 * pi / lambda;
omega = 2 * pi * f;

% Bucle de animación
figure;
for n = 1:length(t)
    % Ecuación de la onda viajera (sentido derecho: x - v*t)
    y = A * sin(k * x - omega * t(n) + phi0);
    
    plot(x, y, 'LineWidth', 2);
    ylim([-A*1.2 A*1.2]);
    grid on;
    title(['Onda Viajera en t = ', num2str(t(n), '%.2f'), ' s']);
    xlabel('Posición (x)');
    ylabel('Amplitud (y)');
    drawnow;
end
