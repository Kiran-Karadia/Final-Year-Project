function [output] = LBPTH(image, threshold)

max_val = max(max(image));

cut_off = threshold * max_val;

output = image;


output(output >= cut_off) = 1 ;

output(output < 1) = 0;


end

