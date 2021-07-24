function [my_dv, my_tof_dv] = calc_Rx_measurements(img_dim, no_measurements,no_sensors, true_image, sens_map)

my_dv = zeros(no_measurements, 1);
my_dv_index = 1;

my_tof_dv = zeros(no_measurements, 1);
my_tof_dv_index = 1;

true_image = reshape(true_image, [img_dim, img_dim]);
% Loop through each Tx
for tx = 1:no_sensors
    % Loop through each Rx for current Tx
    for rx = 1:no_sensors-5
        % If no inclusion is within the path, sensor loss is 0
        rx_val = 0;
        ToF_val = 0;
        % Loop through each row in true image
        for i = 1:img_dim
            % Loop through each col in true image
            for j = 1:img_dim
                % If within an inclusion, accumulate sensor loss using
                % respective sens map pixel value 
                rx_val = rx_val + (true_image(i,j) * sens_map(my_dv_index,i,j));
                if true_image(i,j) == 1
                    if sens_map(my_dv_index,i,j) > 0.8*max(sens_map(my_dv_index,:,:))
                        ToF_val = ToF_val + 0.25;
                    end
                end
              
            end
        end
        my_dv(my_dv_index) = round(rx_val);
        my_dv_index = my_dv_index + 1;
        
        my_tof_dv(my_tof_dv_index) = ToF_val;
        my_tof_dv_index = my_tof_dv_index + 1;
    end
end

end

