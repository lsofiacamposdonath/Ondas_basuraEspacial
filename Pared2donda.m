% 1. Abrir la interfaz randtool para verificar/ajustar parámetros de la distribución Normal
% En la ventana de randtool selecciona: Distribution = Normal, Mu = mu_ruido, Sigma = sigma_ruido
randtool; 

% Parámetros delimitados (los mismos que configures en randtool)
mu_ruido    = 0;      % Media (Mu en randtool)
sigma_ruido = 0.20;   % Desviación estándar (Sigma en randtool)[cite: 1]

% 2. Definir la malla espacial vectorizada y la posición de la pared[cite: 1]
N = 300;
x = linspace(-5, 5, N);
[X, Y] = meshgrid(x, x); %[cite: 1]

% MODIFICACIÓN: Fuente ubicada a la izquierda para que la onda viaje hacia la derecha
x_source = -2.5;      % Origen a la izquierda (antes era 0)[cite: 1]
y_source = 0;         % Centrada verticalmente[cite: 1]
x_wall   = 2.2;       % Posición de la pared reflectante a la derecha[cite: 1]

% 3. Radios para onda incidente y onda reflejada (Método de imágenes)[cite: 1]
R_inc = sqrt((X - x_source).^2 + (Y - y_source).^2); %[cite: 1]
R_ref = sqrt((X - (2*x_wall - x_source)).^2 + (Y - y_source).^2); %[cite: 1]

% Parámetros de propagación de la onda viajera[cite: 1]
k = 6;                % Número de onda (frecuencia espacial)[cite: 1]
w = 2*pi;             % Frecuencia angular temporal[cite: 1]
v = w / k;            % Velocidad de fase de la onda[cite: 1]

% 4. Ventana (envolvente) Gaussiana 2D definida con sigma_x y sigma_y como medida de visión[cite: 1]
sigma_x = 1.8;        % Alcance de visión horizontal de la ventana[cite: 1]
sigma_y = 1.8;        % Alcance de visión vertical de la ventana[cite: 1]
envolvente_2D = exp(-((X.^2) / (2 * sigma_x^2) + (Y.^2) / (2 * sigma_y^2))); %[cite: 1]

% Máscara física: la onda no atraviesa la pared (todo a la derecha de x_wall es 0)[cite: 1]
mascara_pared = double(X <= x_wall); %[cite: 1]

% 5. Configuración de la Figura 2D (Panel único)[cite: 1]
figure('Color', 'w', 'Position', [150, 150, 650, 550]); %[cite: 1]
ax = axes; %[cite: 1]
h_img = imagesc(x, x, zeros(N, N)); %[cite: 1]
hold(ax, 'on');
% Dibujar línea vertical que representa la pared física en x_wall y marcar la fuente[cite: 1]
xline(ax, x_wall, 'w--', 'LineWidth', 2, 'Label', 'Pared (x_{wall})'); %[cite: 1]
plot(ax, x_source, y_source, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6);
hold(ax, 'off');

axis(ax, 'image'); %[cite: 1]
colormap(ax, 'parula'); %[cite: 1]
colorbar(ax); %[cite: 1]
clim(ax, [-1.5 1.5]); %[cite: 1]
title(ax, 'Onda Circular (Izquierda \rightarrow Derecha) + Rebote + Ventana Gaussiana');
xlabel(ax, 'X'); ylabel(ax, 'Y'); %[cite: 1]

% 6. Ciclo FOR para generar los fotogramas de propagación y rebote[cite: 1]
% Tiempo ampliado (hasta 10 s) para cubrir la mayor distancia desde x_source = -2.5 hasta x_wall = 2.2 y su regreso
t_vec = linspace(0, 10, 220); 

for i = 1:length(t_vec)
    t = t_vec(i); %[cite: 1]

    % Frente de avance: limita la onda para que viaje de izquierda a derecha, choque y regrese[cite: 1]
    frente_inc = double(R_inc <= v * t); %[cite: 1]
    frente_ref = double(R_ref <= v * t); %[cite: 1]

    % Onda incidente (viaja de izquierda a derecha) y onda reflejada (regresa hacia la izquierda)[cite: 1]
    onda_inc = frente_inc .* cos(k * R_inc - w * t); %[cite: 1]
    onda_ref = frente_ref .* cos(k * R_ref - w * t); %[cite: 1]

    % Superposición (el signo menos impone reflexión rígida en la pared)[cite: 1]
    onda_total = (onda_inc - onda_ref) .* mascara_pared; %[cite: 1]

    % Ruido Gaussiano vectorizado sobre toda la malla 2D (X)[cite: 1]
    ruido_gauss = mu_ruido + sigma_ruido * randn(size(X)); %[cite: 1]

    % Aplicar la ventana Gaussiana 2D (sigma_x, sigma_y) que delimita la visión[cite: 1]
    Z_2D = envolvente_2D .* (onda_total + ruido_gauss) .* mascara_pared; %[cite: 1]

    % Actualizar fotograma en pantalla[cite: 1]
    set(h_img, 'CData', Z_2D); %[cite: 1]
    drawnow; %[cite: 1]
    pause(0.03); %[cite: 1]
end