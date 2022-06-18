function radianceMap = mergeLDRStack(imgStack , exposureTimes , option)
%MERGELDRSTACK Summary of this function goes here
%   Detailed explanation goes here
    K = size(imgStack, 2);
    [X, Y, ~] = size(imgStack{1});
    
    weightsRed = [];
    lnE_red = [];
    for k = 1:K
        img = imgStack{k};
        W_z = weightingFunction(img(:, :, 1), exposureTimes(k), option);
        weightsRed = cat(3, weightsRed, W_z);
        lnE_red = cat(3, lnE_red, W_z .* (img(:, : , 1) - log(exposureTimes(k))));
    end
    lnE_red = sum(lnE_red, 3) ./ sum(weightsRed, 3);
   
    weightsGreen = [];
    lnE_green = [];
    for k = 1:K
        img = imgStack{k};
        W_z = weightingFunction(img(:, :, 2), exposureTimes(k), option);
        weightsGreen = cat(3, weightsGreen, W_z);
        lnE_green = cat(3, lnE_green, W_z .* (img(:, : , 2) - log(exposureTimes(k))));
    end
    lnE_green = sum(lnE_green, 3) ./ sum(weightsGreen, 3);
    
    weightsBlue = [];
    lnE_blue = [];
    for k = 1:K
        img = imgStack{k};
        W_z = weightingFunction(img(:, :, 3), exposureTimes(k), option);       
        weightsBlue = cat(3, weightsBlue, W_z);
        lnE_blue = cat(3, lnE_blue, W_z .* (img(:, : , 3) - log(exposureTimes(k))));
    end
    lnE_blue = sum(lnE_blue, 3) ./ sum(weightsBlue, 3);
    
    radianceMap = cat(3, lnE_red, cat(3, lnE_green, lnE_blue));
    
    
   
    
    
    
    

