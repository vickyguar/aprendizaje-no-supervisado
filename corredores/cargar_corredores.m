%% CARGAR_CORREDORES
% =========================================================================
% DESCRIPCIÓN:
%   Carga el archivo 'corredores.txt' que contiene datos de rendimiento
%   de corredores en diferentes distancias (kilómetros). 
%
% ARCHIVO FUENTE:
%   corredores.txt - Archivo de texto separados por tabs/tabulaciones (\t)
%
% VARIABLES CREADAS:
%   km4     - Tiempos de carrera en 4 km
%   km8     - Tiempos de carrera en 8 km
%   km12    - Tiempos de carrera en 12 km
%   km16    - Tiempos de carrera en 16 km
%
% FORMATO DEL ARCHIVO:
%   Encabezado (se salta): km4  km8  km12  km16
%   Datos:                 Números separados por tabulación
%
% =========================================================================

%% Inicializar variables.
filename = 'datos/corredores.txt';
delimiter = '\t';
startRow = 2; % los datos comienzan en fila 2 (fila 1 es encabezado)

%% Especificar formato para cada línea de texto:
%   Columna 1: double (km4)
%   Columna 2: double (km8)
%   Columna 3: double (km12)
%   Columna 4: double (km16)
formatSpec = '%f%f%f%f%[^\n\r]';

%% Leer el archivo de texto.
fileID = fopen(filename, 'r');

if fileID == -1
    error('No se pudo abrir el archivo: %s', filename);
end

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines', startRow-1, 'ReturnOnError', false);

fclose(fileID);

%% Asignar datos importados a variables
km4 = dataArray{:, 1};  % tiempos en 4 km
km8 = dataArray{:, 2};  % tiempos en 8 km
km12 = dataArray{:, 3}; % tiempos en 12 km
km16 = dataArray{:, 4}; % tiempos en 16 km

%% Limpiar variables temporales
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Información de carga
fprintf('\n=== DATOS CARGADOS ===\n');
fprintf('Total de corredores: %d\n', length(km4));