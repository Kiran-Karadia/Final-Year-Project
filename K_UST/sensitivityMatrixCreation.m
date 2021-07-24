clear

img_dim = 31;
no_sensors = 16;
img = zeros(img_dim, img_dim);

%centre = round((img_dim-1)/2);

centre = (img_dim-1)/2;
sensor_edges = zeros(1,2);
index_counter = 1;
increment = 0.1;

sensor_angle_inc = 360 / (no_sensors*2);

sensors = zeros(no_sensors, 2);
midpoints = zeros(no_sensors, 2);

at_sensor = 1;

for angle = -90:increment:270
    sensor_edges(index_counter, :) = round([(sind(angle)+1)*centre+1, (cosd(angle)+1)*centre+1]);
    index_counter = index_counter + 1;
end
sensor_edges = unique(sensor_edges, 'rows', 'stable');


    


%%
for i = 1:length(sensor_edges)
    img(sensor_edges(i,1), sensor_edges(i,2)) = 1;
    %draw_image(img, 1);
end

img(round(centre+1), round(centre+1)) = 1;
draw_image(img, 1);

% Have coordinates of the outer edge of the system
% Get coordinates of each sensor
% Get midpoints (for the better sensitivity


