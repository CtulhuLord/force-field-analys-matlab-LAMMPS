function extract_atom_data(filename)
    % Открытие файла для чтения
    fid = fopen(filename, 'r');
    
    % Проверка, что файл был открыт успешно
    if fid == -1
        error('Не удалось открыть файл %s', filename);
    end
    
    % Пропуск ненужных строк до раздела "Atoms"
    while true
        tline = fgetl(fid);
        if contains(tline, 'Atoms # full')
            break;
        end
    end
    
    % Чтение данных атомов
    atom_data = [];
    while true
        tline = fgetl(fid);
        if ~ischar(tline) || isempty(tline)
            break;
        end
        atom_data = [atom_data; sscanf(tline, '%d %d %d %f %f %f %f %d %d %d')'];
    end
    
    % Закрытие файла
    fclose(fid);
    
    % Извлечение данных для молекул 1 и 3-8
    mol_ids = [1, 3, 4, 5, 6, 7, 8];
    selected_atoms = atom_data(ismember(atom_data(:, 3), mol_ids), :);
    
    % Вывод координат и зарядов
    fprintf('ID атома   ID молекулы   Заряд    Координата X      Координата Y      Координата Z\n');
    fprintf('------------------------------------------------------------------------------------\n');
    for i = 1:size(selected_atoms, 1)
        fprintf('%8d   %11d   %5.3f   %12.6f   %12.6f   %12.6f\n', ...
            selected_atoms(i, 1), selected_atoms(i, 3), selected_atoms(i, 4), ...
            selected_atoms(i, 5), selected_atoms(i, 6), selected_atoms(i, 7));
    end
end

% Пример использования
extract_atom_data('system.data');