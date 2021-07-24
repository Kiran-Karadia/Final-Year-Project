function [image] = create_random_object(img_dim, area, position, val)

image = zeros(img_dim, img_dim);

row = position(1);
col = position(2);
image(row, col) = val;

for i = 1:area
    direction = randi([1 4],1);
    switch direction
        case 1
            row = row - 1;
        case 2
            col = col + 1;
        case 3
            row = row + 1;
        case 4
            col = col - 1;
    end
    
    if row < 1
        row = 1;
    elseif col < 1
        col = 1;
    elseif row > img_dim
        row = img_dim;
    elseif col > img_dim
        col = img_dim;
    end
    
    if image(row, col) == val
        i = i - 1;
    else
        image(row, col) = val;
    end

end

