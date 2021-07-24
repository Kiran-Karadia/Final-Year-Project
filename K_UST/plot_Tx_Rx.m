function [TxRxSenseMap] = plot_Tx_Rx(img, sensor, midpoints, Tx, Rx)

TxRxSenseMap = zeros(length(img), length(img));
p1 = sensor(Tx, :); % Point 1 (Tx)
p2 = sensor(Rx, :); % Point 2 (Rx)

if Rx == 1
    m1 = midpoints(length(midpoints), :); % Midpoint before Rx (looped back)
else
    m1 = midpoints(Rx-1, :); % Midpoint before Rx
end
m2 = midpoints(Rx, :); % Midpoint after Rx


% Angle between the two sensors
theta = atan2(p2(1,1) - p1(1,1), p2(1,2) - p1(1,2));

% Start at transmit sensor
count = 0;
x = 0;
y = 0;
% While line is not a receiver
while x ~= p2(1,1) || y ~= p2(1,2)
    % Draw current part of line
    x = round(p1(1,1) + count*sin(theta));   
    y = round(p1(1,2) + count*cos(theta));
    if img(x,y) ~= 1    
        TxRxSenseMap(x, y) = 1;       
    end
    count = count + 0.5; % Lower increment = more detailed line
end

%draw_image(TxRxSenseMap, 2);
%end
end

