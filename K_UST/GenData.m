%clear
img_dim = 64;
no_sensors = 32;
[sens_map, no_measurements, img] = setup_sensors(img_dim, no_sensors);

sens_maps_shaped = reshape(sens_map, [no_measurements, img_dim^2]);

load("C:/Users/UKGC/Desktop/FYP/Datasets/CNN_test/dv_data/aa_dv/aa_dv.mat")
load("C:/Users/UKGC/Desktop/FYP/Datasets/CNN_test/dv_data/tof_dv/tof_dv.mat")

%%
index = 1;


%%
a = reshape(sum(sens_map, 1), [64 64]);

b = reshape(sens_map(10, :, :), [64 64]);
draw_image(b, 2, 1, "")
colorbar off
draw_image(a, 1, 1, "")
colorbar off


%% Create and save true and LBP images
dir_string = "C:/Users/UKGC/Desktop/FYP/Datasets/CNN_test/OG100/";

% true_img = imread("C:/Users/UKGC/Desktop/FYP/Datasets/dv_data/real_data/True_images/true_image8.png");
% load("C:/Users/UKGC/Desktop/FYP/Datasets/dv_data/real_data/dv_data/dv10.mat")
% real_dv = abs(dv');
% load("C:/Users/UKGC/Desktop/FYP/Datasets/dv_data/real_data/dv_tof_data/dv_tof10.mat")
% real_tof = dv_tof';
% true_img = sum(true_img, 3);
% true_img(true_img==0) = 1;
% true_img(true_img>1) = 0;
% 
% a = real_dv-real_tof;
% disp(sum(a))
%%
dataset_length = 1500;
counter = 1;
dv = zeros(1, no_measurements);
tof_dv = zeros(1, no_measurements);
for i = 1:dataset_length
    
    true_img = generate_true_images(img_dim);
  
    % Get images and dv data
    [aa_lbp, tof_lbp, current_dv, current_tof_dv] = Simulate_measurements(img_dim, no_measurements, no_sensors, true_img, sens_map, sens_maps_shaped);
    %[dv, tof_dv] = Acoustic_Attenuation(img_dim, no_measurements, no_sensors, true_img, sens_map);
    dv(counter, :) = current_dv;
    tof_dv(counter, :) = current_tof_dv;
    % Save LBP + threshold image
    LBPTH_img = LBPTH(aa_lbp, 0.75);

end
    string = sprintf(dir_string + "True_image/images/true_image%d.png", i);
    %imwrite(true_img, string);
     
    string = sprintf(dir_string + "AA_LBP_image/images/aa_lbp_image%d.png", i);
    %imwrite(aa_lbp, string);
 
    string = sprintf(dir_string + "ToF_LBP_image/images/tof_lbp_image%d.png", i);
    %imwrite(tof_lbp, string);
     
    string = sprintf(dir_string + "AA_LBPTH_image/images/aa_lbpth_image%d.png", i);
    %imwrite(LBPTH_img, string);
    
%     dv_string = sprintf(dir_string + "dv_data/aa_dv/aa_dv2.mat", i);
%     save(dv_string, "dv");
%     
%     tof_dv_string = sprintf(dir_string + "dv_data/tof_dv/tof_dv2.mat", i);
%     save(tof_dv_string, "tof_dv");
 
    
    
%        draw_image(true_img, 1, 1, "True")
%        draw_image(aa_lbp, 2, 1, "u2")
%        draw_image(tof_lbp, 3, 1, "u3")
%        draw_image(LBPTH_img, 4, 1, "lbp th")
disp(sprintf("Done image %d", i))
counter = counter + 1;
end

string = sprintf(dir_string + "dv_data/aa_dv/aa_dv.mat");
%save(string, "dv");
string = sprintf(dir_string + "dv_data/tof_dv/tof_dv.mat");
%save(string, "tof_dv");








