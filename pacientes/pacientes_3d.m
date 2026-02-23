%% VISUALIZACIÓN 3D Y AJUSTE DE PLANO
% =========================================================================
% DESCRIPCIÓN:
%   Visualiza datos clínicos de pacientes en espacio 3D y analiza
%   la posibilidad de ajustar un plano a los puntos.
%
% DATASETS UTILIZADOS:
%   - MAP (presión arterial media)
%   - Edad (del paciente)
%   - Peso (en kg)
%
% PREGUNTAS A RESOLVER:
%   a. ¿Es correcto ajustar un plano mediante cuadrados mínimos?
%      ¿Por qué?
%
%   b. ¿Qué estrategia se sugiere para obtener el plano que mejor
%      ajuste a los datos, utilizando PCA?
%
% SUGERENCIA DE SOLUCIÓN:
%   - Si los puntos están distribuidos en un plano de baja dimensión,
%     se puede usar PCA para encontrar el plano óptimo.
%   - PCA encontrará los 2 eigenvectores con mayor varianza.
%   - El plano estará definido por estos 2 vectores principales.
%
% =========================================================================

%% Cargar datos
fprintf('Cargando datos de pacientes...\n');
cargar_pacientes

X = [Edad Peso MAP];

% VISUALIZACIÓN: Gráfico 3D de los datos
figure('Name', 'Ejercicio 3 - Visualización 3D', 'NumberTitle', 'off')
plot3(MAP, Edad, Peso, 'o', 'MarkerSize', 8, ...
    'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'blue')

% Etiquetas y títulos
xlabel('MAP (Presión Arterial Media) [mmHg]')
ylabel('Edad [años]')
zlabel('Peso [kg]')
title('Datos de pacientes en espacio 3D')
grid on
rotate3d on % Permitir rotación del gráfico

% FUNCIÓN AUXILIAR: Aplicar PCA y encontrar el plano
fprintf('\n--- Aplicando PCA a los datos ---\n');

% Construir matriz de datos
datos = double([MAP(:), Edad(:), Peso(:)]);

% Centrar los datos
datos_cent = datos - mean(datos);

% Matriz de covarianza
Cov = datos_cent' * datos_cent / (size(datos, 1) - 1);

% Descomposición espectral
[V, D] = eig(Cov);

% Ordenar por autovalores descendentes
[~, idx] = sort(diag(D), 'descend');
V_ordenado = V(:, idx);
D_ordenado = D(idx, idx);

fprintf('Autovalores:\n');
for i = 1:3
    fprintf('  λ%d = %.4f (%.2f%% varianza)\n', ...
        i, D_ordenado(i,i), 100*D_ordenado(i,i)/sum(diag(D_ordenado)));
end

fprintf('\nLos 2 primeros autovectores definen el plano óptimo.\n');

%% GRAFICAR EL PLANO
% Los dos primeros eigenvectores definen el plano
v1 = V_ordenado(:, 1);
v2 = V_ordenado(:, 2);

% Centro de los datos (media)
centro = mean(datos);

% Crear una malla en el espacio de los eigenvectores
escala = 30;
t = linspace(-escala, escala, 30);
s = linspace(-escala, escala, 30);
[T, S] = meshgrid(t, s);

% Construir el plano en el espacio original
% Cada punto del plano: centro + t*v1 + s*v2
Plano_X = centro(1) + T.*v1(1) + S.*v2(1);
Plano_Y = centro(2) + T.*v1(2) + S.*v2(2);
Plano_Z = centro(3) + T.*v1(3) + S.*v2(3);

% Graficar el plano sobre los datos
hold on
surf(Plano_X, Plano_Y, Plano_Z, 'FaceAlpha', 0.4, 'FaceColor', 'red', ...
    'EdgeColor', 'none');
hold off

legend('Datos', 'Plano PCA (óptimo)', 'Location', 'best')