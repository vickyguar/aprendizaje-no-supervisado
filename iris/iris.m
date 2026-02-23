%% ANÁLISIS K-MEANS DEL DATASET IRIS
% =========================================================================
% DESCRIPCIÓN:
%   Script que realiza clustering k-eans completo sobre el dataset Iris.
%   Clasifica 150 flores en 3 clusters basándose en sus características
%   morfológicas (sépalo y pétalo).
%
% PREGUNTAS PROPUESTAS:
%   a. ¿Los 3 clusters obtenidos corresponden a las 3 especies reales?
%   b. ¿Qué características diferencian más los clusters?
%   c. ¿Cómo varían los resultados con diferentes valores de k?
%
% =========================================================================

%% Cargar datos
fprintf('\nCargando datos de Iris...\n');
cargar_iris

%% Construir matriz de características
% Usamos las 4 características numéricas
X = [sepal_length sepal_width petal_length petal_width];
N = size(X, 1); % número de muestras

fprintf('Datos cargados: %d flores, 4 características\n\n', N);

%% PARÁMETROS DE K-MEANS
k = 3; % Número de clusters (conocemos que hay 3 especies)

%% NORMALIZACIÓN: Estandarizar las características
% Es importante normalizar pq las características tienen diferentes escalas
% (ej: longitud típicamente mayor que ancho)
X_mean = mean(X);
X_std = std(X);
X_norm = (X - repmat(X_mean, N, 1)) ./ repmat(X_std, N, 1);

fprintf('=== CARACTERÍSTICAS ORIGINALES ===\n');
fprintf('Longitud sépalo - Media: %.2f cm, Desv: %.2f cm\n', X_mean(1), X_std(1));
fprintf('Ancho sépalo    - Media: %.2f cm, Desv: %.2f cm\n', X_mean(2), X_std(2));
fprintf('Longitud pétalo - Media: %.2f cm, Desv: %.2f cm\n', X_mean(3), X_std(3));
fprintf('Ancho pétalo    - Media: %.2f cm, Desv: %.2f cm\n\n', X_mean(4), X_std(4));

%% EJECUTAR K-MEANS
fprintf('Ejecutando K-Means con k = %d clusters...\n\n', k);

% Inicialización manual de centroides (opcional)
% rng(42); % Fijar semilla aleatoria para reproducibilidad
% clusters = k_means(k, X_norm);

% Usando la función k_means incluida en algoritmos/
addpath('../algoritmos');
clusters = k_means(k, X_norm);

%% ANÁLISIS DE CLUSTERS
fprintf('=== RESULTADOS DE CLUSTERING ===\n');
fprintf('Distribución de clusters:\n');

cluster_sizes = zeros(k, 1);
for i = 1:k
    count = sum(clusters == i);
    cluster_sizes(i) = count;
    fprintf('  Cluster %d: %d flores (%.1f%%)\n', i, count, 100*count/N);
end

%% COMPARACIÓN CON ESPECIES REALES
fprintf('\n=== COMPARACIÓN CON CLASIFICACIÓN REAL (SUPERVISADA) ===\n');
fprintf('Especies reales en el dataset:\n');

unique_species = unique(species);
for i = 1:length(unique_species)
    count = sum(strcmp(species, unique_species(i)));
    fprintf('  %s: %d flores (%.1f%%)\n', unique_species{i}, count, 100*count/N);
end

%% CARACTERÍSTICAS MÉDIAS DE CADA CLUSTER
fprintf('=== CARACTERÍSTICAS DE LOS CLUSTERS (DATOS NORMALIZADOS) ===\n');
for i = 1:k
    fprintf('\nCluster %d:\n', i);
    cluster_data = X_norm(clusters == i, :);
    cluster_mean = mean(cluster_data);
    fprintf('  Longitud sépalo:  %.3f (σ: %.3f)\n', cluster_mean(1), std(cluster_data(:,1)));
    fprintf('  Ancho sépalo:     %.3f (σ: %.3f)\n', cluster_mean(2), std(cluster_data(:,2)));
    fprintf('  Longitud pétalo:  %.3f (σ: %.3f)\n', cluster_mean(3), std(cluster_data(:,3)));
    fprintf('  Ancho pétalo:     %.3f (σ: %.3f)\n', cluster_mean(4), std(cluster_data(:,4)));
end

%% VISUALIZACIÓN: 2D (Pétalo length vs width) - Características más discriminantes
figure('Name', 'K-Means Iris Dataset - Pétalos', 'NumberTitle', 'off')
colors = {'k', 'b', 'r'};
for i = 1:k
    plot(X(clusters == i, 3), X(clusters == i, 4), 'o', ...
        'Color', colors{i}, 'MarkerFaceColor', colors{i}, ...
        'MarkerSize', 8, 'DisplayName', sprintf('Cluster %d', i))
    hold on
end
xlabel('Longitud del pétalo [cm]')
ylabel('Ancho del pétalo [cm]')
title(sprintf('K-Means Clustering - Dataset Iris (k=%d)', k))
legend('Location', 'best')
grid on
hold off

%% VISUALIZACIÓN: 3D (Sépalo length vs width, coloreado por cluster)
figure('Name', 'K-Means Iris Dataset - 3D', 'NumberTitle', 'off')
scatter3(X(:, 1), X(:, 2), X(:, 3), 100, clusters, 'filled', 'o')
xlabel('Longitud del sépalo [cm]')
ylabel('Ancho del sépalo [cm]')
zlabel('Longitud del pétalo [cm]')
title(sprintf('K-Means Clustering - Dataset Iris en 3D (k=%d)', k))
colorbar
grid on