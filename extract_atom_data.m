function selected_atoms = extract_atom_data(filename)
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
    line_number = 0;
    while true
        tline = fgetl(fid);
        line_number = line_number + 1;
        
        % Прекратить проверку строк при достижении блока Velocities
        if contains(tline, 'Velocities')
            break;
        end
        
        % Пропустить пустые строки или строки, содержащие только пробелы
        if ~ischar(tline) || isempty(strtrim(tline))
            continue;
        end
        
        data = sscanf(tline, '%d %d %d %f %f %f %f %d %d %d')';
        if length(data) == 10
            atom_data = [atom_data; data];
        else
            fprintf('Строка %d не соответствует ожидаемому формату и будет пропущена: %s\n', line_number, tline);
        end
    end
    
    % Закрытие файла
    fclose(fid);
    
    % Проверка, что в atom_data достаточно столбцов
    if size(atom_data, 2) < 3
        error('Недостаточно столбцов в atom_data. Последняя обработанная строка: %s', tline);
    end
    
    % Извлечение ID молекулы, ID атома, заряда и координат (X, Y, Z) для молекул 1 и 3-8
    mol_ids = [1, 3, 4, 5, 6, 7, 8];
    selected_atoms = atom_data(ismember(atom_data(:, 2), mol_ids), [2, 1, 4, 5, 6, 7]);
end