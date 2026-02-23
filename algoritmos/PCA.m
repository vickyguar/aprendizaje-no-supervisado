%% PCA - Análisis de Componentes Principales
% =========================================================================
% DESCRIPCIÓN:
%   Realiza Análisis de Componentes Principales (PCA) sobre datos normalizados
%   utilizando la matriz de covarianza para reducción de dimensionalidad.
%
% SINTAXIS:
%   a = PCA(x)
%
% PARÁMETROS DE ENTRADA:
%   x           - [Nxd array] Matriz de datos (N muestras, d variables)
%
% SALIDA:
%   a           - [dx1 array] Autovalores normalizados ordenados descendentemente
%
% ALGORITMO:
%   1. Centrar los datos (restar la media)
%   2. Calcular matriz de covarianza
%   3. Descomposición espectral (eigenvalores y eigenvectores)
%   4. Normalizar autovalores (varianza explicada)
%
% RESULTADO GRÁFICO:
%   - Gráfico de stem: autovalores normalizados
%   - Gráfico de línea: varianza acumulada (scree plot)
%
% =========================================================================

function a = PCA(x)

% Setup: Obtener dimensiones de los datos
[m, n] = size(x); % m = número de muestras, n = número de variables

% PASO 1: Centrar los datos (restar la media de cada variable)
Xmed = zeros(size(x));
for i = 1:n
    Xmed(:,i) = mean(x(:,i)); % Media de cada columna
end

% Datos centrados (media = 0)
Xz = x - Xmed;

% PASO 2: Calcular matriz de covarianza
Sigma = Xz'*Xz; % Matriz de covarianza (sin dividir por n, normalización interna)

% PASO 3: Descomposición espectral
% [V, A] = eig(Sigma) 
% V: eigenvectores (componentes principales)
% A: diagonal de autovalores
[V, A] = eig(Sigma);

% PASO 4: Ordenar autovalores en orden descendente (mayor varianza primero)
% Los autovalores representan la varianza explicada en cada dirección
a = sort(diag(A), 'descend'); % Extraer diagonal y ordenar descendentemente
a = a./sum(a); % Normalizar: varianza explicada como proporción total

% Obtener autovectores ordenados (componentes principales principales)
v = fliplr(V); % Invertir orden para que corresponda con autovalores ordenados

% Variable auxiliar (raíz cuadrada de autovalores normalizados)
b = sqrt(a);

% GRÁFICOS
figure
% Gráfico 1: Autovalores normalizados (varianza explicada por componente)
stem(a, 'LineWidth', 2)
hold on
xlabel('Componente Principal')
ylabel('Varianza Explicada')
title('PCA: Autovalores Normalizados (Scree Plot)')
grid on

% PASO 5: Calcular varianza acumulada
acum(1) = a(1);
for i = 2:n
    acum(i) = acum(i-1) + a(i); % Varianza acumulada (suma progresiva)
end

% Gráfico 2: Varianza acumulada
plot(acum, 'o-', 'LineWidth', 2, 'MarkerSize', 6)
legend('Autovalores', 'Varianza Acumulada', 'Location', 'best')
hold off

end