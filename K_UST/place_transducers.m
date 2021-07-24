function [img, sensors] = place_transducers(img_size, no_sensors)
% Set the size of the 'image'
img = zeros(img_size, img_size);

% Centre point of the image
centre = (img_size-1)/2;

% Angle difference between each transducer
angle_increment = 360 / (no_sensors);
% Angle offset (-90 = start at top)
angle = 0;

sensors = zeros(no_sensors, 2);


% Loop through each sensor, make location on image a black dot
for i = 1:no_sensors
    sensors(i,:) = round([(sind(angle)+1)*centre+1, (cosd(angle)+1)*centre+1]);
    img(sensors(i,1), sensors(i,2)) = 1;
    angle = angle - angle_increment;
end



