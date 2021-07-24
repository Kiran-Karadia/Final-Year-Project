function [image] = generate_true_images(img_dim)

image = zeros(img_dim, img_dim);

no_shapes = randi([1 3], 1);

for i = 1:no_shapes   
    shape = randi([1 3], 1);
    switch shape
        case 1 % Rectangle
            image = image + create_rectangle(img_dim, 1);
        case 2 % Circle
            radius = randi([2 10], 1);
            centerX = randi([20 40-radius], 1);
            centerY = randi([20 40-radius], 1);
            image = image + create_circle(img_dim, centerX, centerY, radius);
        case 3 % Triangle
            a = sort(spdiags(toeplitz(1:randi([7 12], 1))));
            a(a>1) = 1;  
            row = randi([30 40], 1);
            col = randi([30 40], 1);
            augment = randi([1 4], 1);
            if augment == 1
                a = a.';
            elseif augment == 2
                a = flip(a);
            elseif augment == 3
                a = flip(a);
                a = a.';
            end
            [x, y] = size(a);
            temp_img = image;
            temp_img(row:row+x-1, col:col+y-1) = a;
            image = image + temp_img;
    end
end  

image(image ~= 0) = 1;

end

