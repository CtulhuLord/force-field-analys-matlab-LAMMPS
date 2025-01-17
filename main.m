% Вызов функции для извлечения данных атомов из файла
result = extract_atom_data('system.data');

% Инициализация массива для хранения ID молекулы, ID атома, заряда и координат (X, Y, Z)
% а также смещенных координат
atom_data_array = [];

% Перебор результата и сохранение данных в массив
for i = 1:size(result, 1)
    % Исходные координаты
    original_x = result(i, 4);
    original_y = result(i, 5);
    original_z = result(i, 6);
    
    % Смещенные координаты
    shifted_x = original_x + 13;
    shifted_y = original_y + 13;
    shifted_xy_x = original_x + 13;
    shifted_xy_y = original_y + 13;
    
    % Сохранение данных в массив
    atom_data_array = [atom_data_array; result(i, 1), result(i, 2), result(i, 3), original_x, original_y, original_z, shifted_x, original_y, original_z, original_x, shifted_y, original_z, shifted_xy_x, shifted_xy_y, original_z];
end

% Сортировка массива по первому столбцу (ID молекулы)
atom_data_array = sortrows(atom_data_array, 1);

% Теперь массив atom_data_array содержит ID молекулы, ID атома, заряд,
% исходные координаты (X, Y, Z), и смещенные координаты (X+13, Y, Z), (X, Y+13, Z), (X+13, Y+13, Z)
% Вы можете использовать этот массив для дальнейшей обработки