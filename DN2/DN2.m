clc;
clear all;

data = readmatrix('vozlisca_temperature_dn2.txt', 'NumHeaderLines', 4);
x = data(:,1); % x-koodrinate vozlisc
y = data(:,2); % y-koordinate vozlisc
T = data(:,3); % temp

cells = readmatrix('celice_dn2.txt', 'NumHeaderLines', 2);

for i = 1:size(cells, 1)
    
    cell_points = cells(i,:); 

    cell_point1 = cell_points(1);
    cell_point2 = cell_points(2);
    cell_point3 = cell_points(3);
    cell_point4 = cell_points(4);

    x1 = x(cell_point1);
    x2 = x(cell_point2);
    x3 = x(cell_point3);
    x4 = x(cell_point4);

    y1 = y(cell_point1);
    y2 = y(cell_point2);
    y3 = y(cell_point3);
    y4 = y(cell_point4);

end


% Koordinati točke, kjer želite izračunati temperaturo
x_query = 0.403;
y_query = 0.503;

%% Interpolacija s scatteredInterpolant
tic;

T_interp = scatteredInterpolant(x, y, T, 'linear', 'none');

T_query = T_interp(x_query, y_query);

time_scattered = toc;

fprintf('Temperatura v točki - scatteredInterpolant (%.3f, %.3f) je %.3f °C.\n', x_query, y_query, T_query);

%% Interpolacija z griddedInterpolant
tic;

% Ustvarjanje mreže (X in Y)
x_unique = unique(x);
y_unique = unique(y);
[X, Y] = meshgrid(x_unique, y_unique);

% Preuredimo temperaturno matriko v NDGRID format
T_grid = reshape(T, length(y_unique), length(x_unique));
T_grid = T_grid';

F_grid = griddedInterpolant(X', Y', T_grid, 'linear', 'none');

T_query = F_grid(x_query, y_query);

time_gridded = toc;

fprintf('Temperatura v točki - griddedInterpolant (%.3f, %.3f) je %.3f °C.\n', x_query, y_query, T_query);

%% Interpolacija z bilinearno interpolacijo
tic;

for i = 1:size(cells, 1)
    cell_points = cells(i, :);
    
    % Koordinate vozlišč celice
    x_min = x(cell_points(1));
    x_max = x(cell_points(2));
    y_min = y(cell_points(1));
    y_max = y(cell_points(3));
    
    % Preverimo, če točka (x_query, y_query) spada v to celico
    if (x_query >= x_min && x_query <= x_max && ...
        y_query >= y_min && y_query <= y_max)
        
        % Temperatura v vozliščih celice
        T11 = T(cell_points(1)); % T(x_min, y_min)
        T21 = T(cell_points(2)); % T(x_max, y_min)
        T12 = T(cell_points(3)); % T(x_min, y_max)
        T22 = T(cell_points(4)); % T(x_max, y_max)
        
        % Bilinearna interpolacija
        K1 = ((x_max - x_query) / (x_max - x_min)) * T11 + ...
             ((x_query - x_min) / (x_max - x_min)) * T21;
        K2 = ((x_max - x_query) / (x_max - x_min)) * T12 + ...
             ((x_query - x_min) / (x_max - x_min)) * T22;
        T_query = ((y_max - y_query) / (y_max - y_min)) * K1 + ...
                  ((y_query - y_min) / (y_max - y_min)) * K2;

        time_bilinear = toc;
        
        fprintf('Temperatura v točki - bilinearna interpolacija (%.3f, %.3f) je %.2f°C\n', x_query, y_query, T_query);
        
        break;
    end
end

%% Primerjava časov
fprintf('\nPrimerjava časov metod:\n');
fprintf('ScatteredInterpolant: %.6f sekund\n', time_scattered);
fprintf('GriddedInterpolant: %.6f sekund\n', time_gridded);
fprintf('Bilinearna interpolacija: %.6f sekund (najhitrejša metoda)\n', time_bilinear);

%% Največja temperatura in njene koordinate
[max_temp, max_idx] = max(T);
max_x = x(max_idx);
max_y = y(max_idx);
fprintf('Največja temperatura: %.2f°C na koordinatah (%.3f, %.3f)\n', max_temp, max_x, max_y);