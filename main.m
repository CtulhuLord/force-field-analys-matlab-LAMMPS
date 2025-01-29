
% Вызов основной функции
sub();

% Основная функция для вызова вычислений и визуализации
function sub()
    % Проверка существования файла interaction_array.mat
    if exist('interaction_array.mat', 'file') ~= 2
        % Выполнение вычислений и сохранение массива interaction_array в файл
        compute_interaction();
    else
        fprintf('Файл interaction_array.mat уже существует. Вычисления пропущены.\n');
    end

    % Параметры для настройки размеров точек
    size_range = [1, 100]; % Диапазон размеров точек
    fixed_size = []; % Оставить пустым для использования диапазона размеров точек
    threshold = 3; % Пороговое значение для определения экстремально больших значений
    
    % Вызов функции визуализации с настройками
    visualize_interaction(size_range, fixed_size, threshold);
end
