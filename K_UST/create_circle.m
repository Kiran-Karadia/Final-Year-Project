function [image] = create_circle(img_dim, centerX, centerY, radius)

[columnsInImage, rowsInImage] = meshgrid(1:img_dim, 1:img_dim);

circlePixels = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= radius.^2;
image = double(circlePixels);

end
