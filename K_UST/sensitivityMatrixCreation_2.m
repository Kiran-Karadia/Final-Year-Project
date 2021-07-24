clear
img_dim = 64;
no_sensors = 32;
% Exclude 2 neighbouring sensors from each side and current Tx
no_measurements = no_sensors * (no_sensors-5);

[img, sensors, midpoints] = place_transducers(img_dim, no_sensors);
draw_image(img, 3, 1, "circle")
sens_map = zeros((no_measurements), img_dim, img_dim);

output = zeros(img_dim, img_dim);

counter = 1;
% Loop for each sensor
for Tx = 1:no_sensors
    %Rxs = (no_sensors/2)+1; % Number of Rxs to measure from (90 degree) 
    Rxs = no_sensors - 5; % (Not using neighbours and Tx as Rxs)
    % Loop for each receiver
    for i = 1:Rxs 
        %current_Rx = Tx + (no_sensors/4) + i - 1; % (90 degree)
        current_Rx = Tx + 2 + i;
        % Loop round circle if needed
        if current_Rx > no_sensors
            current_Rx = current_Rx-no_sensors;
        end       
        % Store individual sensitivity maps
        sens_map(counter,:,:) = plot_Tx_Rx_2(img, sensors, midpoints, Tx, current_Rx);
        counter = counter + 1; 
    end
end

full_sense_map = reshape(sum(sens_map, 1), [img_dim, img_dim]);
% Draw the full sensitivity map
draw_image(full_sense_map, 1, 1, "Full Sensitivity Map");

%% Draw a specific sensitivity map 
%current_map = get_sens_map(sens_map, 2, img_dim);
%draw_image(current_map, 6, 1, sprintf("Sensitivity map %d", sens_map_index));

%% Create true image
no_shapes = 3;
a = zeros(no_shapes, img_dim, img_dim);
a(1,:,:) = create_rectangle(img_dim, 1);
a(2,:,:) = create_rectangle(img_dim, 1);
a(3,:,:) = create_rectangle(img_dim, 1);
% shapes(1, :, :) = create_rectangle(img_dim, 40, 40, [13, 13], 1);
true_image = sum(a, 1);
true_image = reshape(true_image, [img_dim, img_dim]);
draw_image(true_image, 2, 1, "True image")

%% Calculate Rx sensor loss values
my_dv = calc_Rx_loss(img_dim, no_measurements, no_sensors, true_image, sens_map);

%% LBP
sens_maps_shaped = reshape(sens_map, [no_measurements, img_dim^2]);

load dv
load egSenseMap % 3D matrix of each individual sensitivity map
dv = dv(:,2);
eg_Sense_Map = A; % Loads in as 'A' so just renameing here
% Reshape and sum to get superimposed (full) sensitivity map
%full_eg_sense_map = sum(reshape(eg_Sense_Map.', [64, 64, 864]), 3);
%draw_image(full_eg_sense_map, 2, 1, "Example Sensitivity map");


A = sens_maps_shaped'*my_dv;
%xx = eg_Sense_Map'*my_dv;

% Reshape to be able to display
Au = reshape(A, [img_dim, img_dim]);
%Xu = reshape(xx, [64, 64]);
Au(:,:) = abs(Au(:,:));
Au(:,:) = Au(:,:) / max(max(Au(:,:)));
% Display both image reconstructions from dv data
for i = 2:2
    draw_image(Au, 3, 1, sprintf("My Image Reconstruction %d", i));
    %draw_image(Xu, 4, 1, sprintf("Example Image Reconstruction %d", i));
    %plot_title = sprintf("My Img Recon %d                                           |                                 Example Img Recon %d", i, i);
    %draw_image([Xu(:,:,i), zeros(64, 1), Au(:,:,i)], 3, 0, plot_title);
end
%save('C:\Users\UKGC\Desktop\FYP\Datasets\Valid\Au.mat', 'Au');
% dV is the strendth you multiply the sensitivity map by for each
% corresponding Tx to Rx and then the summation of them is the final image

%% LBP Hybrid method (thresholding)
A2 = sens_map.*my_dv;
Bhr = zeros(64,64);

max_val = max(max(abs(Au)));
threshold = 0.5 * max_val;
for i = 1:64
    for j = 1:64
        if abs(Au(i,j)) >= threshold
            Bhr(i,j) = 1;
        end
    end
end
        
draw_image(Bhr.*Au, 7, 1, "Thresholded")

%% Create and Save true images
no_shapes = 3;
shapes = zeros(img_dim, img_dim, no_shapes);
dv = zeros(no_measurements, no_shapes);
r = round(15 + (45-15)*rand(no_shapes, 1));
r2 = round(15 + (45-15)*rand(no_shapes, 1));
s = round(5 + (20-5)*rand(no_shapes, 1));
s2 = round(5 + (20-5)*rand(no_shapes, 1));
for i = 1:2:no_shapes-1 
    shapes(:, :, i) = create_rectangle(img_dim, s(i), s2(i),  [r(i), r2(i)], 1);
    radius = randi([2 20], 1);
    shapes(:, :, i+1) = create_circle(img_dim, randi([15 64-radius], 1), randi([15 64-radius], 1), radius);
    dv(:,i) = calc_Rx_loss(img_dim, no_measurements, no_sensors, shapes(:, :, i), sens_map);
    dv(:,i+1) = calc_Rx_loss(img_dim, no_measurements, no_sensors, shapes(:, :, i+1), sens_map);
    %draw_image(reshape(shapes(i,:,:), [img_dim, img_dim]), 5, 1, sprintf("True image %d", i))
end

%% Create random shapes and calc Rx loss
no_shapes = 1000;
shapes = zeros(img_dim, img_dim, no_shapes);
dv = zeros(no_measurements, no_shapes);
for i = 1:no_shapes 
    shapes(:, :, i) = create_random_object(img_dim, randi([100 300], 1), [randi([20 img_dim-20], 1), randi([20 img_dim-20], 1)], 1);
    dv(:,i) = calc_Rx_loss(img_dim, no_measurements, no_sensors, shapes(:, :, i), sens_map);
    %draw_image(reshape(shapes(:,:,i), [img_dim, img_dim]), 5, 1, sprintf("True image %d", i))
end
%% LBP
sens_maps_shaped = reshape(sens_map, [no_measurements, img_dim^2]);
xx = sens_maps_shaped'*dv;
k = reshape(xx, [64, 64, no_shapes]);
u = zeros(64, 64, no_shapes);
for i = 1:no_shapes
    u(:,:,i) = abs(k(:,:,i));
    u(:,:,i) = u(:,:,i) / max(max(u(:,:,i)));
end
%%
for i = 1:3
    draw_image(shapes(:,:,i), 5, 1, i);
    draw_image(u(:,:,i), 6, 1, i);
    draw_image(k(:,:,i), 8, 1, i);
end
%%
%save('C:/Users/UKGC\Desktop\FYP\Code\FYP\K_UST\Dataset\dv.mat', 'dv');
save('C:\Users\UKGC\Desktop\FYP\Datasets\Test\true_images_test.mat', 'shapes');
save('C:\Users\UKGC\Desktop\FYP\Datasets\Training\img_recons_test.mat', 'u');


%%
no_imgs = 10000;
dataset = zeros(img_dim, img_dim, no_imgs);
% for i = 1:no_imgs
%     draw_image(dataset(:,:,i), 1, 1, i)
% end
sens_maps_shaped = reshape(sens_map, [no_measurements, img_dim^2]);
dv = zeros(no_measurements, no_imgs);
for i = 1:no_imgs
    dataset(:,:,i) = generate_dataset(img_dim);
    dv(:,i) = calc_Rx_loss(img_dim, no_measurements, no_sensors, dataset(:, :, i), sens_map);
end
xx = sens_maps_shaped'*dv;
k = reshape(xx, [64, 64, no_imgs]);
u = zeros(64, 64, no_imgs);
for i = 1:no_imgs
    u(:,:,i) = abs(k(:,:,i));
    u(:,:,i) = u(:,:,i) / max(max(u(:,:,i)));
end