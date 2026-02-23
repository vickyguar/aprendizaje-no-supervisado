%% CARGAR_IRIS
% =========================================================================
% DESCRIPCIÓN:
%   Carga el archivo 'Iris.csv' que contiene las medidas de flores iris
%   de la familia de clasificación botánica de Anderson-Fisher.
%
% ARCHIVO FUENTE:
%   Iris.csv - Archivo de valores separados por comas (CSV)
%
% VARIABLES CREADAS:
%   sepal_length    - Longitud del sépalo en cm
%   sepal_width     - Ancho del sépalo en cm
%   petal_length    - Longitud del pétalo en cm
%   petal_width     - Ancho del pétalo en cm
%   species         - Especie de iris (Iris-setosa, Iris-versicolor, Iris-virginica)
%
% FORMATO DEL ARCHIVO:
%   Encabezado (se salta): Id,SepalLengthCm,SepalWidthCm,PetalLengthCm,PetalWidthCm,Species
%   Datos:                 Números y etiquetas separados por comas
%
% DATASET:
%   Total de muestras: 150 flores
%   Total de características: 4 variables numéricas + especie
%   3 especies de iris con 50 muestras cada una
%
% =========================================================================

%% Inicializar variables.
filename = 'datos/Iris.csv';
delimiter = ',';
startRow = 2; % los datos comienzan en fila 2 (fila 1 es encabezado)

%% Especificar formato para cada línea de texto:
%   Columna 1: double (Id)
%   Columna 2: double (SepalLengthCm)
%   Columna 3: double (SepalWidthCm)
%   Columna 4: double (PetalLengthCm)
%   Columna 5: double (PetalWidthCm)
%   Columna 6: string (Species)
formatSpec = '%d%f%f%f%f%s%[^\n\r]';

%% Leer el archivo de texto.
fileID = fopen(filename, 'r');

if fileID == -1
    error('No se pudo abrir el archivo: %s', filename);
end

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines', startRow-1, 'ReturnOnError', false);

fclose(fileID);

%% Asignar datos importados a variables
sepal_length = double(dataArray{:, 2});   % Longitud del sépalo en cm
sepal_width = double(dataArray{:, 3});    % Ancho del sépalo en cm
petal_length = double(dataArray{:, 4});   % Longitud del pétalo en cm
petal_width = double(dataArray{:, 5});    % Ancho del pétalo en cm
species = dataArray{:, 6};                % Especie de iris

%% Limpiar variables temporales
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Información de carga
fprintf('\n=== DATOS CARGADOS (IRIS DATASET) ===\n');
fprintf('Total de flores: %d\n', length(sepal_length));
fprintf('Características: 4 (SepalLength, SepalWidth, PetalLength, PetalWidth)\n');
fprintf('Especies: Iris-setosa, Iris-versicolor, Iris-virginica\n');
