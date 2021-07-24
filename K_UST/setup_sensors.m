function [sens_map, no_measurements, img] = setup_sensors(img_dim,no_sensors)

no_measurements = no_sensors * (no_sensors-5);

[img, sensors] = place_transducers(img_dim, no_sensors);

sens_map = zeros((no_measurements), img_dim, img_dim);


counter = 1;
% Loop for each sensor
for Tx = 1:no_sensors
    %Rxs = (no_sensors/2)+1; % Number of Rxs to measure from (90 degree) 
    Rxs = no_sensors - 5; % (Not using neighbours and Tx as Rxs)
    % Loop for each receiver
    for i = 1:Rxs 
        %current_Rx = Tx + (no_sensors/4) + i - 1; % (90 degree)
        current_Rx = Tx + 3 + i;
        % Loop round circle if needed
        if current_Rx > no_sensors
            current_Rx = current_Rx-no_sensors;
        end       
        % Store individual sensitivity maps
        sens_map(counter,:,:) = plot_Tx_Rx_2(img, sensors, Tx, current_Rx);
        counter = counter + 1; 
    end
end


end

