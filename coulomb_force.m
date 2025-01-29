function compute_interaction(step)
    % Вызов функции для извлечения данных атомов из файла
    result = extract_atom_data('system.data');
    fprintf('Данные атомов загружены.\n');

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
        atom_data_array = [atom_data_array; result(i, 1), result(i, 2), result(i, 3), original_x, original_y, original_z, shifted_x, original_y, original_z, original_x, shifted_y, original_z, shifted_xy_x, shifted_xy_y];
    end

    % Сортировка массива по первому столбцу (ID молекулы)
    atom_data_array = sortrows(atom_data_array, 1);
    fprintf('Данные атомов подготовлены.\n');

    % Инициализация массива для хранения взаимодействий и координат электрона
    interaction_array = [];

    % Общие количество итераций для расчета прогресса
    total_iterations = numel(0:step:13) * numel(0:step:13) * numel(-10:step:110);
    current_iteration = 0;

    % Создание шкалы прогресса
    h = waitbar(0, 'Вычисление взаимодействий, пожалуйста, подождите...');

    % Создание пула рабочих для параллельных вычислений
    pool = gcp();
    num_workers = pool.NumWorkers;
    fprintf('Пул рабочих создан с %d рабочими.\n', num_workers);

    % Инициализация массива для хранения задач
    tasks = [];

    % Перебор всех положений электрона по x от 0 до 13, y от 0 до 13, z от -10 до 110
    for x = 0:step:13
        for y = 0:step:13
            for z = -10:step:110
                % Запуск параллельной задачи
                f = parfeval(pool, @compute_interaction_step, 1, x, y, z, atom_data_array);
                tasks = [tasks; f];
            end
        end
    end
    fprintf('Все задачи запущены.\n');

    % Ожидание завершения задач и обновление прогресс-бара
    for i = 1:length(tasks)
        % Получение результата
        result = fetchOutputs(tasks(i));
        interaction_array = [interaction_array; result];

        % Обновление шкалы прогресса
        current_iteration = current_iteration + 1;
        waitbar(current_iteration / total_iterations, h);

        % Логирование в консоль
        fprintf('Взаимодействие завершено: %d из %d\n', current_iteration, total_iterations);
    end

    % Закрытие шкалы прогресса
    close(h);

    % Сохранение массива interaction_array и значения step в файл
    save('interaction_array.mat', 'interaction_array', 'step');

    % Вывод результата
    fprintf('Вычисление взаимодействий завершено и данные сохранены в файл.\n');
end

function interaction = compute_interaction_step(x, y, z, atom_data_array)
    % Координаты электрона
    electron_coords = [x, y, z];
    electron_charge = -1; % Заряд электрона в эквивалентных зарядах электрона

    % Инициализация переменной для суммарного значения энергии
    total_energy = 0;
    
    fprintf('Начало вычисления для координат (%d, %d, %d).\n', x, y, z);

    % Перебор массива atom_data_array и вычисление взаимодействий
    for i = 1:size(atom_data_array, 1)
        % Координаты и заряд атома
        atom_charge = atom_data_array(i, 3);
        normal_coord = atom_data_array(i, 4:6);
        shifted_x_coord = atom_data_array(i, 7:9);
        shifted_y_coord = atom_data_array(i, 10:12);
        shifted_xy_coord = atom_data_array(i, 13:15);

        % Логирование перед вызовом coulomb_force
        fprintf('Вызов coulomb_force: атом_charge=%f, нормальные координаты=%s, электрона координаты=%s\n', atom_charge, mat2str(normal_coord), mat2str(electron_coords));
        energy_normal = coulomb_force(electron_charge, atom_charge, electron_coords, normal_coord);
        fprintf('Результат coulomb_force: energy_normal=%f\n', energy_normal);
        total_energy = total_energy + energy_normal;

        % Логирование перед вызовом coulomb_force для смещенных координат (X+13)
        fprintf('Вызов coulomb_force: атом_charge=%f, смещенные координаты (X+13)=%s\n', atom_charge, mat2str(shifted_x_coord));
        energy_shifted_x = coulomb_force(electron_charge, atom_charge, electron_coords, shifted_x_coord);
        fprintf('Результат coulomb_force: energy_shifted_x=%f\n', energy_shifted_x);
        total_energy = total_energy + energy_shifted_x;

        % Логирование перед вызовом coulomb_force для смещенных координат (Y+13)
        fprintf('Вызов coulomb_force: атом_charge=%f, смещенные координаты (Y+13)=%s\n', atom_charge, mat2str(shifted_y_coord));
        energy_shifted_y = coulomb_force(electron_charge, atom_charge, electron_coords, shifted_y_coord);
        fprintf('Результат coulomb_force: energy_shifted_y=%f\n', energy_shifted_y);
        total_energy = total_energy + energy_shifted_y;

        % Логирование перед вызовом coulomb_force для смещенных координат (X+13, Y+13)
        fprintf('Вызов coulomb_force: атом_charge=%f, смещенные координаты (X+13, Y+13)=%s\n', atom_charge, mat2str(shifted_xy_coord));
        energy_shifted_xy = coulomb_force(electron_charge, atom_charge, electron_coords, shifted_xy_coord);
        fprintf('Результат coulomb_force: energy_shifted_xy=%f\n', energy_shifted_xy);
        total_energy = total_energy + energy_shifted_xy;
    end

    % Логирование завершения вычисления текущего взаимодействия
    fprintf('Вычисление для координат (%d, %d, %d) завершено.\n', x, y, z);

    % Добавление результирующей величины энергии и координат электрона в массив
    interaction = [total_energy, electron_coords];
end

function F_magnitude = coulomb_force(q1, q2, coord1, coord2)
    % Функция для вычисления величины силы кулоновского взаимодействия между двумя зарядами
    % q1, q2 - заряды в эквивалентных зарядах электрона
    % coord1, coord2 - координаты зарядов в ангстремах [x, y, z]

    % Определение коэффициента пропорциональности в вакууме (Н·м²/Кл²)
    k = 8.9875e9; % Н·м²/Кл²

    % Константы
    e_charge = 1.602e-19; % Заряд электрона в кулонах
    avogadro_number = 6.022e23; % Постоянная Авогадро (моль⁻¹)
    joules_to_kcal = 1 / 4184; % Конвертация джоулей в килокалории

    % Перевод зарядов в кулоны
    q1_coulombs = q1 * e_charge;
    q2_coulombs = q2 * e_charge;

    % Перевод координат из ангстремов в метры
    coord1_meters = coord1 * 1e-10;
    coord2_meters = coord2 * 1e-10;

    % Вычисление расстояния между зарядами в метрах
    r_vector = coord2_meters - coord1_meters;
    r = norm(r_vector);

    % Проверка на нулевое расстояние, чтобы избежать деления на ноль
    if r == 0
        F_magnitude = 0;
        return;
    end

    % Вычисление величины силы кулоновского взаимодействия в Ньютонах
    F_magnitude_H = 1/330.72 * k * (q1_coulombs * q2_coulombs) / r;
    F_magnitude = F_magnitude_H * avogadro_number * joules_to_kcal;
end