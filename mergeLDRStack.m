
% Paper: Recovering High Dynamic Range Radiance Maps from Photographs

function [radianceMapRed, radianceMapGreen, radianceMapBlue] = mergeLDRStack(imgStack , exposureTimes , option)
%MERGELDRSTACK Summary of this function goes here
%   Detailed explanation goes here
    global Zmax;
    
    K = size(imgStack, 2);
    [X ,Y, ~] = size(imgStack{1});
    
    totalWeightsRed = zeros(X,Y);
    HDR_Red = zeros(X,Y);
    
    totalWeightsGreen = zeros(X,Y);
    HDR_Green = zeros(X,Y);
    
    totalWeightsBlue = zeros(X,Y);
    HDR_Blue = zeros(X,Y);
    
    for k = 1:K        
        tk = exposureTimes(k);
        currentImage = imgStack{k};
      
        channel = currentImage(:, :, 1);      
        weightOfZ= weightingFunction(channel, exposureTimes(k), option);
        totalWeightsRed = totalWeightsRed + weightOfZ;        
        HDR_Red = HDR_Red + weightOfZ .* (log(channel) - log(tk));
        
        channel = currentImage(:, :, 2);      
        weightOfZ= weightingFunction(channel, exposureTimes(k), option);
        totalWeightsGreen = totalWeightsGreen + weightOfZ;        
        HDR_Green = HDR_Green + weightOfZ .* (log(channel) - log(tk));
       
        channel = currentImage(:, :, 3);      
        weightOfZ= weightingFunction(channel, exposureTimes(k), option);
        totalWeightsBlue = totalWeightsBlue + weightOfZ;        
        HDR_Blue = HDR_Blue + weightOfZ .* (log(channel) - log(tk));
        
    end
    
    radianceMapRed = HDR_Red ./ totalWeightsRed;
    radianceMapRed(totalWeightsRed == 0) = Zmax;
    
    radianceMapGreen = HDR_Green ./ totalWeightsGreen;
    radianceMapGreen(totalWeightsGreen == 0) = Zmax;
    
    radianceMapBlue = HDR_Blue ./ totalWeightsBlue;
    radianceMapBlue(totalWeightsBlue == 0) = Zmax;
    
    
    
    
   
    
    
    
    

