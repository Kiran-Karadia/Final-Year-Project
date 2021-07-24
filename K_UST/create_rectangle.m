function [object_image] = create_rectangle(img_dim, val)
% Create a square object
% Length = columns, height = rows
% Position is considered as the top left corner

length = randi([5 20], 1);
height = randi([5 20], 1);
posX = randi([20 40], 1);
posY = randi([20 40], 1);
object_image = zeros(img_dim, img_dim);

% Top left, top right, bottom left, bottom right coordinates of 
tl = [posX, posY];
tr = [posX, posY+length-1];
bl = [posX+height-1, posY];
br = [posX+height-1, posY+length-1];


object_image(posX:posX+height-1, posY:posY+length-1) = val;

end

