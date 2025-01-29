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