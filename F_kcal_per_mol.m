function F_kcal_per_mol = coulomb_force(q1, q2, coord1, coord2)
    % Функция для вычисления силы кулоновского взаимодействия между двумя зарядами
    % q1, q2 - заряды в эквивалентных зарядах электрона
    % coord1, coord2 - координаты зарядов в ангстремах [x, y, z]
    
    % Определение коэффициента пропорциональности в вакууме (Н·м²/Кл²)
    k = 8.9875e9; % Н·м²/Кл²
    
    % Константы
    e_charge = 1.602e-19; % Заряд электрона в кулонах
    angstrom_to_meter = 1e-10; % Конвертация ангстремов в метры
    avogadro_number = 6.022e23; % Постоянная Авогадро (моль⁻¹)
    joules_to_kcal = 1 / 4184; % Конвертация джоулей в килокалории
    
    % Перевод зарядов в кулоны
    q1_coulombs = q1 * e_charge;
    q2_coulombs = q2 * e_charge;
    
    % Перевод координат в метры
    coord1_meters = coord1 * angstrom_to_meter;
    coord2_meters = coord2 * angstrom_to_meter;
    
    % Вычисление расстояния между зарядами в метрах
    r = sqrt((coord2_meters(1) - coord1_meters(1))^2 + (coord2_meters(2) - coord1_meters(2))^2 + (coord2_meters(3) - coord1_meters(3))^2);
    
    % Вычисление силы кулоновского взаимодействия в Ньютонах
    F_newtons = k * (q1_coulombs * q2_coulombs) / r^2;
    
    % Перевод силы из Ньютонах в килокалории на моль
    F_joules_per_molecule = F_newtons * r;
    F_joules_per_mol = F_joules_per_molecule * avogadro_number;
    F_kcal_per_mol = F_joules_per_mol * joules_to_kcal;
end