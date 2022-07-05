
% Paper: Recovering High Dynamic Range Radiance Maps from Photographs

function radianceMap = mergeLDRStack(imgStack , exposureTimes , option)
%MERGELDRSTACK Summary of this function goes here
%   Detailed explanation goes here
    K = size(imgStack, 2);
    [X ,Y]= size(imgStack{1});
    
    totalWeights = zeros(X,Y);
    totalMetric = zeros(X,Y);
   
    for k = 1:K     
        tk = exposureTimes(k);
        currentImage = imgStack{k};
        weightOfZ= weightingFunction(currentImage, tk, option);
        totalWeights = totalWeights + weightOfZ;     
        imageLog = log(currentImage);
        imageLog(isinf(imageLog)) = 0;
        totalMetric = totalMetric + weightOfZ .* (imageLog - log(tk));
    end
   
    [totalMetric, totalWeights] = managePixelOutliers(totalMetric,...
        totalWeights, imgStack{8});
    
    radianceMap = totalMetric ./ totalWeights;
    
   
    
    
    
    
    
   
    
    
    
    

