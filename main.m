result = extract_atom_data('system.data');

% Вывод координат и зарядов
fprintf('ID атома   ID молекулы   Заряд    Координата X      Координата Y      Координата Z\n');
fprintf('------------------------------------------------------------------------------------\n');
for i = 1:size(result, 1)
    fprintf('%8d   %11d   %5.3f   %12.6f   %12.6f   %12.6f\n', ...
        result(i, 1), result(i, 3), result(i, 4), ...
        result(i, 5), result(i, 6), result(i, 7));
end