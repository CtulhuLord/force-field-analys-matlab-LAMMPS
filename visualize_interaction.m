function visualize_interaction()
    % Загрузка массива interaction_array из файла
    load('interaction_array.mat', 'interaction_array');

    % Нормировка размера точек от 1 до 10
    magnitudes = abs(interaction_array(:, 1));
    min_magnitude = min(magnitudes);
    max_magnitude = max(magnitudes);
    sizes = 1 +  999 * (magnitudes - min_magnitude) / (max_magnitude - min_magnitude);

    % Визуализация данных
    figure;
    hold on;

    % Определение цветов для визуализации
    colors = zeros(size(interaction_array, 1), 3);
    for i = 1:size(interaction_array, 1)
        if interaction_array(i, 1) > 0
            colors(i, :) = [1, 0, 0]; % красный для положительных значений
        elseif interaction_array(i, 1) < 0
            colors(i, :) = [0, 0, 1]; % синий для отрицательных значений
        else
            colors(i, :) = [0.5, 0, 0.5]; % фиолетовый для значений близких к нулю
        end
    end

    % Нанесение точек на график
    scatter3(interaction_array(:, 5), interaction_array(:, 6), interaction_array(:, 7), sizes, colors);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Visualization of Interaction Vectors');
    colorbar;
    hold off;

    % Вывод результата
    fprintf('Визуализация завершена.\n');
end