
% Вызов основной функции
calc();

% Основная функция для вызова вычислений и визуализации
function calc()
    % Проверка существования файла interaction_array.mat
    if exist('interaction_array.mat', 'file') ~= 2
        % Выполнение вычислений и сохранение массива interaction_array в файл
        compute_interaction();
    else
        fprintf('Файл interaction_array.mat уже существует. Вычисления пропущены.\n');
    end

    % Визуализация массива interaction_array
    visualize_interaction();
end