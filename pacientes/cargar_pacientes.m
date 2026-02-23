%% CARGAR_CORREDORES
% =========================================================================
% DESCRIPCIÓN:
%   Carga el archivo 'pacientes.txt' que contiene datos DUMMIES (falsos y
%   generados automáticamente) de pacientes.
%
% ARCHIVO FUENTE:
%   pacientes.txt - Archivo de texto separados por tabs/tabulaciones (\t)
%
% VARIABLES CREADAS:
%   Paciente - identificador del paciente
%   Edad     - edad del paciente
%   Peso     - peso del paciente
%   MAP      - Presión Arterial Media
%
% FORMATO DEL ARCHIVO:
%   Encabezado (se salta): Paciente  Edad  Peso_kg  MAP_mmHg
%   Datos:                 Números separados por tabulación
%
% =========================================================================

%% Inicializar variables.
filename = 'datos/pacientes.txt';
delimiter = '\t';
startRow = 2; % los datos comienzan en fila 2 (fila 1 es encabezado)

%% Especificar formato para cada línea de texto:
%   Columna 1: double (número de paciente) → sé que es int pero sino tira error :(
%   Columna 2: double (edad) → sé que es int pero sino tira error
%   Columna 3: double (peso)
%   Columna 4: double (MAP)
formatSpec = '%d%d%f%f%[^\n\r]';

%% Leer el archivo de texto.
fileID = fopen(filename, 'r');

if fileID == -1
    error('No se pudo abrir el archivo: %s', filename);
end

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines', startRow-1, 'ReturnOnError', false);

fclose(fileID);

%% Asignar datos importados a variables
Edad = dataArray{:, 2};
Peso = dataArray{:, 3};
MAP = dataArray{:, 4};

%% Limpiar variables temporales
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Información de carga
fprintf('\n=== DATOS CARGADOS ===\n');
fprintf('Total de pacientes: %d\n', length(MAP));