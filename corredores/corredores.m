%% ANÁLISIS PCA DEL DATASET DE CORREDORES
% =========================================================================
% DESCRIPCIÓN:
%   Script que realiza análisis de componentes principales (PCA) completo
%   sobre el dataset de rendimiento de corredores en diferentes distancias.
%   Incluye visualización de componentes principales y análisis de varianza.
%
% DATOS UTILIZADOS:
%   - Tiempos de corredores en 4 distancias: 4km, 8km, 12km, 16km
%   - Almacenados en: corredores.txt
%
% INTERPRETACIÓN:
%   - Los primeros autovalores indican en qué dirección hay más variabilidad
%   - La varianza acumulada muestra cuántos componentes se necesitan
%   - Los gráficos permiten reducir dimensionalidad manteniendo información
%
% =========================================================================

%% Cargar datos
fprintf('Cargando datos de corredores...\n');
cargar_corredores

%% Construir matriz
X = [km4 km8 km12 km16];
N = size(X,1); % número de corredores

fprintf('Datos cargados: %d corredores, 4 distancias\n\n', N);

%% Centrar X restando la media (normalización)
% !!!! Es muy importante porque la covarianza requiere datos centrados
Xz = X - repmat(mean(X), N, 1); % restar media de cada columna

%% Calcular matriz de covarianza (S)
S = Xz'*Xz / N;

%% Descomposición espectral de la matriz de covarianza
% [V, D] = eig(S)
% V = autovectores (definen las nuevas direcciones/componentes principales)
% D = diagonal con autovalores (varianza en cada dirección)
[V, D] = eig(S);

%% Procesar autovalores
% Los autovalores siempre están en orden ascendente
% Los invertimos para tener orden descendente (mayor varianza primero!!!)
% L = autovalores normalizados (proporción de varianza explicada)
L = flipud(diag(D)/sum(diag(D)));

% Varianza acumulada (cuánta varianza total se explica con k componentes)
Lacum = cumsum(L);

fprintf('=== ANÁLISIS DE AUTOVALORES ===\n');
fprintf('Varianza explicada por componente:\n');
for i = 1:length(L)
    fprintf('  PC%d: %.4f (%.2f%% | Acumulada: %.2f%%)\n', ...
        i, L(i), L(i)*100, Lacum(i)*100);
end

%% GRÁFICOS: Autovalores y variabilidad acumulada
figure('Name', 'Análisis de Varianza', 'NumberTitle', 'off')
subplot(2,1,1)
plot(1:length(L), L, 'o-', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(1:length(L), Lacum, 's-', 'LineWidth', 2, 'MarkerSize', 8)
title('Autovalores y Variabilidad Acumulada')
xlabel('Número de autovalor (Componente Principal)')
ylabel('Autovalor normalizado / Variabilidad acumulada')
legend('Autovalores', 'Variabilidad Acumulada', 'Location', 'best')
grid on
ylim([0 1.05])

%% Proyectar X sobre los autovectores
% Transformar datos al espacio de componentes principales
% Y = X * V produce las nuevas coordenadas
Y = X*V;

%% GRÁFICO: Primeras dos componentes principales
% MATLAB devuelve autovalores/autovectores de menor a mayor !!!!!
% Por lo tanto: PC1 = Y(:,4), PC2 = Y(:,3), etc.
subplot(2,1,2)
scatter(Y(:,4), Y(:,3), 100, 'filled', 'o')
title('Primeras dos Componentes Principales')
xlabel('PC1 (primera componente principal)');
ylabel('PC2 (segunda componente principal)');

% Etiquetar cada punto con número de corredor
text(Y(:,4), Y(:,3), arrayfun(@num2str, 1:N, 'UniformOutput', false), ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', ...
    'FontSize', 9)
grid on

%% GRÁFICO: Comparación de varianzas (dato original vs PCA)
figure('Name', 'Comparación de Varianzas', 'NumberTitle', 'off')
% Invertir autovectores para que correspondan con el orden de Y
V_flipped = fliplr(V);
Var_original = var(X)';
Var_PCA = var(Y)';

categories = {'Km4', 'Km8', 'Km12', 'Km16'};
x_pos = 1:4;
width = 0.35;

bar(x_pos - width/2, Var_original, width, 'FaceColor', 'b', 'EdgeColor', 'b')
hold on
bar(x_pos + width/2, Var_PCA, width, 'FaceColor', 'r', 'EdgeColor', 'r')

title('Varianzas: Variables Originales vs Componentes Principales')
xlabel('Variable / Componente')
ylabel('Varianza')
set(gca, 'XTick', x_pos)
set(gca, 'XTickLabel', categories)
legend('Originales', 'PCA', 'Location', 'best')
grid on

fprintf('\nNota importante:\n');
fprintf('  - La variabilidad TOTAL se preserva en PCA\n');
fprintf('  - suma(var(X)) = suma(var(Y))\n');
fprintf('  - PCA agrupa la variabilidad en menos dimensiones\n');
fprintf('  - Esto permite reducción de dimensionalidad\n\n');