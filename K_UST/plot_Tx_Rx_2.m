function [TxRxSensMapGauss] = plot_Tx_Rx(img, sensor,Tx, Rx)

TxRxSensMap = zeros(length(img), length(img));
p1 = sensor(Tx, :); % Point 1 (Tx)
p2 = sensor(Rx, :); % Point 2 (Rx)




% Angle between the two sensors
theta = atan2(p2(1,1) - p1(1,1), p2(1,2) - p1(1,2));

% Start at transmit sensor
count = 0;
x = round(p1(1,1) + count*sin(theta));
y = round(p1(1,2) + count*cos(theta));
% While line is not a receiver

while x ~= p2(1,1) || y ~= p2(1,2)
    % Draw current part of line
    if TxRxSensMap(x,y) ~= 1    
        TxRxSensMap(x, y) = 1;       
    end
    
    count = count + 0.5; 
    
    x = round(p1(1,1) + count*sin(theta));   
    y = round(p1(1,2) + count*cos(theta));
end


TxRxSensMapGauss = imgaussfilt(TxRxSensMap, 1.25, 'Padding', 0);


end

