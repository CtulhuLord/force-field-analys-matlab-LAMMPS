function visualize_interaction(size_range, fixed_size, threshold)
    % Определение цветов для экстремально больших значений
    extreme_positive_color = [1, 0, 0]; % Красный для экстремально больших положительных значений
    extreme_negative_color = [0.5, 0, 0.5]; % Тёмно-фиолетовый для экстремально больших отрицательных значений

    % Загрузка массива interaction_array из файла
    load('interaction_array.mat', 'interaction_array');

    % Нормировка размеров точек
    if isempty(fixed_size)
        magnitudes = abs(interaction_array(:, 1));
        % Исключение экстремально больших значений из нормализации
        magnitudes_filtered = magnitudes(magnitudes <= threshold);
        min_magnitude = min(magnitudes_filtered);
        max_magnitude = max(magnitudes_filtered);
        sizes = size_range(1) + (size_range(2) - size_range(1)) * (magnitudes - min_magnitude) / (max_magnitude - min_magnitude);
    else
        sizes = fixed_size * ones(size(interaction_array, 1), 1);
    end

    % Отдельная нормализация для положительных и отрицательных значений
    positive_values = interaction_array(:, 1) > 0;
    negative_values = interaction_array(:, 1) < 0;
    
    % Нормализация положительных значений
    positive_magnitudes = interaction_array(positive_values, 1);
    positive_magnitudes_filtered = positive_magnitudes(positive_magnitudes <= threshold);
    if ~isempty(positive_magnitudes_filtered)
        normalized_positive = (positive_magnitudes - min(positive_magnitudes_filtered)) / (max(positive_magnitudes_filtered) - min(positive_magnitudes_filtered));
    else
        normalized_positive = [];
    end

    % Нормализация отрицательных значений
    negative_magnitudes = abs(interaction_array(negative_values, 1));
    negative_magnitudes_filtered = negative_magnitudes(negative_magnitudes <= threshold);
    if ~isempty(negative_magnitudes_filtered)
        normalized_negative = (negative_magnitudes - min(negative_magnitudes_filtered)) / (max(negative_magnitudes_filtered) - min(negative_magnitudes_filtered));
    else
        normalized_negative = [];
    end

    % Создание массива цветов с использованием стандартных цветов MATLAB
    colors = zeros(size(interaction_array, 1), 3);
    colormap_1 = colormap('parula'); % Используем стандартную colormap 'parula'
    colormap_2 = colormap('jet');    % Используем стандартную colormap 'jet'

    % Установка цветов для положительных значений
    positive_indices = find(positive_values);
    for i = 1:length(positive_indices)
        if interaction_array(positive_indices(i), 1) > threshold
            colors(positive_indices(i), :) = extreme_positive_color;
        else
            color_index = round(normalized_positive(i) * (size(colormap_1, 1) - 1)) + 1;
            color_index = max(1, min(color_index, size(colormap_1, 1))); % Проверка границ индекса
            colors(positive_indices(i), :) = colormap_1(color_index, :);
        end
    end

    % Установка цветов для отрицательных значений
    negative_indices = find(negative_values);
    for i = 1:length(negative_indices)
        if abs(interaction_array(negative_indices(i), 1)) > threshold
            colors(negative_indices(i), :) = extreme_negative_color;
        else
            color_index = round(normalized_negative(i) * (size(colormap_2, 1) - 1)) + 1;
            color_index = max(1, min(color_index, size(colormap_2, 1))); % Проверка границ индекса
            colors(negative_indices(i), :) = colormap_2(color_index, :);
        end
    end

    % Визуализация данных (объемная)
    figure('Name', 'Volume Visualization');
    hold on;
    scatter3(interaction_array(:, 2), interaction_array(:, 3), interaction_array(:, 4), sizes, colors, 'filled');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Visualization of Interaction Magnitudes');
    colorbar;
    hold off;

    % Создание интерактивного окна для срезов
    slice_fig = figure('Name', 'Slice Visualization');
    slice_ax = axes(slice_fig);
    h = uicontrol(slice_fig, 'Style', 'slider', 'Min', min(interaction_array(:, 4)), 'Max', max(interaction_array(:, 4)), 'Value', min(interaction_array(:, 4)), 'Position', [400 20 120 20]);
    addlistener(h, 'Value', 'PostSet', @(src, event) updateSlice(slice_ax, interaction_array, event.AffectedObject.Value, colors));

    % Первоначальный вызов функции для отображения начального среза
    updateSlice(slice_ax, interaction_array, min(interaction_array(:, 4)), colors);

    % Создание окна для гистограммы
    figure('Name', 'Histogram of Interaction Values');
    histogram(interaction_array(:, 1));
    xlabel('Interaction Values');
    ylabel('Frequency');
    title('Histogram of Interaction Values');

    % Вывод результата
    fprintf('Визуализация завершена.\n');
end

function updateSlice(slice_ax, interaction_array, slice_value, colors)
    % Функция для обновления среза
    slice_index = round(slice_value);
    slice_data = interaction_array(abs(interaction_array(:, 4) - slice_index) < 1e-5, :); % Предполагается срез по координате Z

    % Визуализация среза в виде поверхности (монотонная поверхность)
    if ~isempty(slice_data)
        axes(slice_ax); % Установить текущие оси
        cla(slice_ax);  % Очистить текущие оси
        hold on;
        % Построение поверхности
        [X, Y] = meshgrid(unique(slice_data(:, 2)), unique(slice_data(:, 3)));
        Z = griddata(slice_data(:, 2), slice_data(:, 3), slice_data(:, 4), X, Y);
        C = griddata(slice_data(:, 2), slice_data(:, 3), slice_data(:, 1), X, Y); % Используем значения для цвета
        surf(slice_ax, X, Y, Z, C);
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        title(slice_ax, sprintf('Slice Visualization at Z = %.2f', slice_value));
        colorbar;
        hold off;
    end
end