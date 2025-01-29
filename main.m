% Ввод значения step
step = input('Введите значение step: ');

% Вызов основной функции с переданным значением step
sub(step);

% Основная функция для вызова вычислений и визуализации
function sub(step)
    % Проверка существования файла interaction_array.mat
    if exist('interaction_array.mat', 'file') == 2
        % Загрузка сохраненного значения step из файла interaction_array.mat
        saved_data = load('interaction_array.mat');
        
        if isfield(saved_data, 'step') && saved_data.step == step
            fprintf('Файл interaction_array.mat уже существует и step совпадает. Вычисления пропущены.\n');
        else
            fprintf('Файл interaction_array.mat существует, но step отличается. Пересчет взаимодействий...\n');
            % Выполнение вычислений и сохранение массива interaction_array в файл
            compute_interaction(step);
        end
    else
        % Выполнение вычислений и сохранение массива interaction_array в файл
        compute_interaction(step);
    end

    % Параметры для настройки размеров точек
    size_range = [1, 100]; % Диапазон размеров точек
    fixed_size = []; % Оставить пустым для использования диапазона размеров точек
    threshold = 3; % Пороговое значение для определения экстремально больших значений
    
    % Вызов функции визуализации с настройками
    visualize_interaction(size_range, fixed_size, threshold);
end