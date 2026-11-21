% 1. Definir la malla espacial vectorizada
N = 300;
x = linspace(-5, 5, N);
[X, Y] = meshgrid(x, x);

% 2. Radio isotrópico para la onda circular
R = sqrt(X.^2 + Y.^2);
k = 6;                          % Frecuencia espacial de la onda circular
onda_isotropica = cos(k * R);   % Onda circular isotrópica

% 3. Ventana (envolvente) Gaussiana 2D definida con sigma_x y sigma_y
sigma_x = 1.8; 
sigma_y = 1.8;
envolvente_2D = exp(-((X.^2) / (2 * sigma_x^2) + (Y.^2) / (2 * sigma_y^2)));

% 4. Ruido Gaussiano vectorizado (media = 0, desviación estándar = sigma_ruido)
sigma_ruido = 0.25;
ruido_gaussiano = normrnd(0, sigma_ruido, size(X)); % Equivalente a: sigma_ruido * randn(size(X))

% 5. Señal resultante (Onda circular isotrópica + ruido gaussiano dentro de la ventana 2D)
Z = envolvente_2D .* (onda_isotropica + ruido_gaussiano);

% 6. Visualización estática en 2 paneles (igual al primer programa)
figure('Color', 'w', 'Position', [100, 100, 1100, 450]);

% Panel 1: Vista 3D (Relieve)
subplot(1, 2, 1);
surf(X, Y, Z, 'EdgeColor', 'none');
colormap(parula);
lighting gouraud; camlight headlight;
title('Vista 3D: Onda Circular + Ruido Gaussiano en Ventana 2D');
xlabel('X'); ylabel('Y'); zlabel('Amplitud');
view(-35, 45);

% Panel 2: Vista 2D (Mapa de intensidad)
subplot(1, 2, 2);
imagesc(x, x, Z);
axis image; colorbar;
title('Vista 2D: Ventana Gaussiana (\sigma_x, \sigma_y)');
xlabel('X'); ylabel('Y');

% 7. Animación solo en el panel 2D
omega = 2*pi*0.5;              % frecuencia angular (rad/s) -> periodo T = 2 s
t = linspace(0, 4, 120);       % 120 cuadros en 4 s (dos periodos)
clim([-1.5 1.5]);              % fija la escala de colores (en versiones viejas: caxis)

for n = 1:numel(t)
    onda_t  = cos(k*R - omega*t(n));                 % onda que viaja hacia afuera
    % ruido_t = sigma_ruido * randn(size(X));        % <- esta línea se quita (o se comenta)
    Z_t = envolvente_2D .* (onda_t + ruido_gaussiano);   % <- esta es la línea nueva

    h.CData = Z_t;
    drawnow;
    pause(0.03);
end