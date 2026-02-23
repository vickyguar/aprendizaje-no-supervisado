%% K-MEANS - Algoritmo de Clustering
% =========================================================================
% DESCRIPCIÓN:
%   Implementa el algoritmo K-Means para agrupar datos en k clusters.
%   Utiliza el método de Forgy para inicialización de centroides.
%
% SINTAXIS:
%   C = k_means(k, x)
%   C = k_means(k, x, centroide)
%   C = k_means(k, x, centroide, l)
%
% PARÁMETROS DE ENTRADA:
%   k           - [int] Número de clusters a crear
%   x           - [Nxd array] Matriz de datos (N muestras, d dimensiones)
%   centroide   - [kxd array] Centroides iniciales (opcional)
%   l           - [int] Número de iteración actual (uso interno, opcional)
%
% SALIDA:
%   C           - [Nx1 array] Vector de asignaciones de cluster para cada punto
%
% EJEMPLO:
%   x = [1 2; 2 1; 8 8; 8 9; 9 8];
%   clusters = k_means(2, x);
%   scatter(x(:,1), x(:,2), [], clusters, 'filled');
% =========================================================================

function C = k_means(k, x, centroide, l)

% Setup
N = length(x(:,1)); % el ", 1 " esta asumiendo que es la primera dimension

% Gráfico inicial de los datos
figure(1)
plot(x(:,1), x(:,2), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b')
title('Datos iniciales')
xlabel('Dimensión 1')
ylabel('Dimensión 2')

if nargin < 3
    
    l = 1; % Inicializar contador de iteraciones
    
    % Inicialización de los centroides usando método de Forgy
    % (seleccionar k puntos aleatorios del dataset como centroides iniciales)
    r = randi([1, N + 1], 1, k);

    % Inicializar matriz de centroides
    centroide = zeros(k, length(x(1,:)));
    for i = 1:k
        centroide(i) = x(r(i));
    end
    
    % Mensaje de instrucción
    fprintf('\n=== K-MEANS EN PROGRESO ===\n');
    fprintf('Presiona CTRL+C en cualquier momento para detener las iteraciones.\n');
    fprintf('Iteraciones máximas: 200\n\n');
end

% Inicializar vector de asignaciones de cluster para cada punto
C = zeros(N, 1);

% LOOP: Iterar hasta convergencia o máximo de iteraciones
max_iterations = 200;
while l <= max_iterations
    
    % PASO 1: Asignación - Asignar cada punto al cluster más cercano
    for f = 1 : N
        d_min = inf; % Inicializar distancia mínima como infinito
        
        for j = 1 : k
            
            % Calcular distancia euclidiana del punto al centroide
            d = abs(x(f) - centroide(j));
            
            % Si es la primera cluster o la distancia es menor a la actual
            if(j == 1 || d_min > d)
                d_min = d;
                C(f) = j; % Asignar punto al cluster j
            end 
        end
    end
    
    % Guardar centroides anteriores para detectar convergencia
    centroide_ant = centroide;
    
    % PASO 2: Actualización - Recalcular centroides como media de cada cluster
    for i = 1:k
        centroide(i,1) = sum(x(C == i, 1))/length(x(C == i, 2));
        centroide(i,2) = sum(x(C == i, 2))/length(x(C == i, 2));
    end
    
    % Mostrar progreso de iteraciones
    if mod(l, 10) == 0 || l == 1
        fprintf('  Iteración %d/%d\n', l, max_iterations);
    end
    
    % Permitir que MATLAB procese eventos (permite presionar Ctrl+C)
    drawnow;
    
    % Criterio de convergencia: si los centroides no cambian mucho, parar
    if sum(sum(abs(centroide - centroide_ant))) < 1e-6
        fprintf('  Convergencia alcanzada en iteración %d\n\n', l);
        break;
    end
    
    l = l + 1;
end

fprintf('K-Means completado en %d iteraciones.\n\n', l);

% Visualizar resultado final con colores para cada cluster
figure(2)
colors = {'k','b','r','g','y',[.5 .6 .7],[.8 .2 .6]};
for i = 1: k
    plot(x(C == i ,1), x(C == i,2), 'o','color',colors{i})
    hold on
end
title(sprintf('Resultado K-Means (k=%d, iteraciones=%d)', k, l))
xlabel('Dimensión 1')
ylabel('Dimensión 2')
legend(arrayfun(@(n) sprintf('Cluster %d', n), 1:k, 'UniformOutput', false))

end