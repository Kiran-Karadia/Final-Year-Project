function [current_map] = get_sens_map(sens_map, index, img_dim)
% Get a specific sensitivity map 
% Reshape to remove dimension of 1 (able to display)
current_map = sens_map(index, :, :);
current_map = reshape(current_map, [img_dim, img_dim]);

end

