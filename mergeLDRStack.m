
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
        totalMetric = totalMetric + weightOfZ .* (log(currentImage) - log(tk));
        
    end
   
    [totalMetric, totalWeights] = managePixelOutliers(totalMetric,...
        totalWeights, imgStack{1});
    
    radianceMap = totalMetric ./ totalWeights;
    
   
    
    
    
    
    
   
    
    
    
    

