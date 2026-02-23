%% ANÁLISIS PCA CON MATRIZ DE CORRELACIÓN
% =========================================================================
% DESCRIPCIÓN:
%   Script que realiza Análisis de Componentes Principales (PCA) usando
%   la matriz de CORRELACIÓN en lugar de la matriz de covarianza.
%   Útil cuando las variables tienen diferentes escalas.
%
% PROPÓSITO:
%   Aplicar PCA al dataset clínico de pacientes y comparar resultados
%   obtenidos con matriz de correlación vs. matriz de covarianza.
%
% PARÁMETROS DE ENTRADA:
%   x           - [Nxd array] Matriz de datos de pacientes
%
% SALIDA:
%   a           - [dx1 array] Autovalores normalizados (varianza explicada)
%
% PREGUNTAS PROPUESTAS:
%   a. ¿Qué diferencias observa entre PCA con covarianza vs correlación?
%   b. ¿Cuál es más apropiado para este problema? ¿Por qué?
%   c. Analice los coeficientes de las 2 primeras componentes principales.
%
% NOTAS:
%   - La matriz de correlación es preferible cuando las variables
%     tienen diferentes unidades o escalas.
%   - Los autovalores de la correlación siempre están normalizados a [0,1].
%
% =========================================================================

%% Cargar datos
fprintf('Cargando datos de pacientes...\n');
cargar_pacientes

x = double([Edad Peso MAP]);

% Setup: Obtener dimensiones
[m, n] = size(x); % m = muestras, n = variables

% Inicializar matriz de medias (opcional, para centrado manual)
Xmed = zeros(size(x));
for i = 1:n
    Xmed(:,i) = mean(x(:,i));
end

% PASO 1: Calcular matriz de CORRELACIÓN de Pearson
% corrcoef(x) devuelve la matriz de correlación (normalizando por escala)
% Esto es diferente a PCA.m que usa covarianza sin normalizar
[V, A] = eig(corrcoef(x)); 

% PASO 2: Extraer y ordenar autovalores (mayor a menor varianza)
a = sort(diag(A), 'descend'); % Autovalores de la matriz de correlación
a = a./sum(a); % Normalizar (varianza acumulada suma a 1)

% Obtener autovectores (componentes principales) ordenados
v = fliplr(V); % Invertir orden para corresponder con autovalores ordenados

% Variable auxiliar
b = sqrt(a);

% GRÁFICOS DE RESULTADOS
figure

% Gráfico 1: Autovalores (Scree Plot)
% Cada autovalor representa la importancia relativa de cada componente
stem(a, 'LineWidth', 2)
hold on
xlabel('Componente Principal')
ylabel('Varianza Explicada')
title('PCA (Matriz de Correlación): Autovalores Normalizados')
grid on

% PASO 3: Calcular varianza acumulada
% Muestra cuánta varianza total se explica con k componentes
acum(1) = a(1);
for i = 2:n
    acum(i) = acum(i-1) + a(i);
end

% Gráfico 2: Varianza acumulada
% Útil para determinar número de componentes requeridos
plot(acum, 'o-', 'LineWidth', 2, 'MarkerSize', 6)
legend('Autovalores', 'Varianza Acumulada', 'Location', 'best')
hold off

% Mostrar información en consola
fprintf('\n=== RESULTADOS PCA ===\n');
fprintf('Variables originales: %d\n', n);
fprintf('Muestras: %d\n', m);
fprintf('\nVarianza explicada por componente:\n');
for i = 1:min(5, n)
    fprintf('  PC%d: %.2f%% (Acumulada: %.2f%%)\n', i, a(i)*100, acum(i)*100);
end