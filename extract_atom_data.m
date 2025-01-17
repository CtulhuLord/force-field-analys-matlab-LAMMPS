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
end