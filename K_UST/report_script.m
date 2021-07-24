clear
index = [1, 6, 2, 18, 20, 16];
%index = [1, 17, 12, 10, 13, 8];
base_str = "C:/Users/UKGC/Desktop/FYP/Datasets/CNN_test/";

for i = 1:6
    string = sprintf(base_str + "/pred%d.png", index(i));
    img = imread(string);
    %img(img~=0) = 1;
    draw_image(img, i, 1, "")  
end

%%
for i = 1:6
    a = tof_dv(index(i), :);
    temp = a*sens_maps_shaped;
    temp = reshape(squeeze(temp), [64, 64]);
    draw_image(temp, i+1, 1, "")
end