function compute_interaction()
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
        atom_data_array = [atom_data_array; result(i, 1), result(i, 2), result(i, 3), original_x, original_y, original_z, shifted_x, original_y, original_z, original_x, shifted_y, original_z, shifted_[...]
    end

    % Сортировка массива по первому столбцу (ID молекулы)
    atom_data_array = sortrows(atom_data_array, 1);

    % Настраиваемый шаг по координатам
    step = 0.5; % можно изменить на любое значение от 0.01 до 1

    % Инициализация массива для хранения взаимодействий и координат электрона
    interaction_array = [];

    % Общие количество итераций для расчета прогресса
    total_iterations = numel(0:step:13) * numel(0:step:13) * numel(-10:step:110);
    current_iteration = 0;

    % Создание шкалы прогресса
    h = waitbar(0, 'Вычисление взаимодействий, пожалуйста, подождите...');

    % Перебор всех положений электрона по x от 0 до 13, y от 0 до 13, z от -10 до 110
    for x = 0:step:13
        for y = 0:step:13
            for z = -10:step:110
                % Координаты электрона
                electron_coords = [x, y, z];
                electron_charge = -1; % Заряд электрона в эквивалентных зарядах электрона

                % Инициализация переменной для суммарного значения взаимодействия
                total_interaction = 0;

                % Перебор массива atom_data_array и вычисление взаимодействий
                for i = 1:size(atom_data_array, 1)
                    % Координаты и заряд атома
                    atom_charge = atom_data_array(i, 3);
                    normal_coord = atom_data_array(i, 4:6);
                    shifted_x_coord = atom_data_array(i, 7:9);
                    shifted_y_coord = atom_data_array(i, 10:12);
                    shifted_xy_coord = atom_data_array(i, 13:15);

                    % Вычисление взаимодействий по нормальным координатам
                    interaction_normal = coulomb_force(electron_charge, atom_charge, electron_coords, normal_coord);
                    total_interaction = total_interaction + interaction_normal;

                    % Вычисление взаимодействий по смещенным координатам (X+13)
                    interaction_shifted_x = coulomb_force(electron_charge, atom_charge, electron_coords, shifted_x_coord);
                    total_interaction = total_interaction + interaction_shifted_x;

                    % Вычисление взаимодействий по смещенным координатам (Y+13)
                    interaction_shifted_y = coulomb_force(electron_charge, atom_charge, electron_coords, shifted_y_coord);
                    total_interaction = total_interaction + interaction_shifted_y;

                    % Вычисление взаимодействий по смещенным координатам (X+13, Y+13)
                    interaction_shifted_xy = coulomb_force(electron_charge, atom_charge, electron_coords, shifted_xy_coord);
                    total_interaction = total_interaction + interaction_shifted_xy;
                end

                % Добавление результирующей величины и координат электрона в массив
                interaction_array = [interaction_array; total_interaction, electron_coords];

                % Обновление шкалы прогресса
                current_iteration = current_iteration + 1;
                waitbar(current_iteration / total_iterations, h);
            end
        end
    end

    % Закрытие шкалы прогресса
    close(h);

    % Сохранение массива interaction_array в файл
    save('interaction_array.mat', 'interaction_array');

    % Вывод результата
    fprintf('Вычисление взаимодействий завершено и данные сохранены в файл.\n');
end