                                                                                                                                                                         % Parámetros físicos
A = 1;              
f = 2;              
lambda = 0.5;       
phi0 = 0;           

omega = 2 * pi * f;      
k = (2 * pi) / lambda;   

% Vectores
x = linspace(0, 2, 128); 
t = 0;

% Calculamos la onda
y = A * sin(omega * t - k * x + phi0);

%obtener el número de datos
num_muestras = length(x);

figure;
plot(x, y, 'b-', 'LineWidth', 2);
grid on;

% Usando length en las etiquetas
xlabel(['Espacio x (metros) - ', num2str(num_muestras), ' muestras']);
ylabel('Elongación y(x,t)');
title(['Fotografía de la Onda (N = ', num2str(length(y)), ' puntos)']);