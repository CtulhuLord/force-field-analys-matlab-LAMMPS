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