  function radianceMap = mergeCalibratedLDRStack(imgStack , exposureTimes, option, curve)
%MERGELDRSTACK Summary of this function goes here
%   Detailed explanation goes here
    K = size(imgStack, 2);
    [X ,Y]= size(imgStack{1});
    
    totalWeights = zeros(X,Y);
    totalMetric = zeros(X,Y);
   
    for k = 1:K     
        tk = exposureTimes(k);
        currentImage = imgStack{k};
        weightOfZ= weightingFunction(im2double(currentImage), tk, option);
        totalWeights = totalWeights + weightOfZ;     
        imageLog = curve(imgStack{k}+1);
        imageLog(isinf(imageLog)) = 0;
        totalMetric = totalMetric + weightOfZ .* (imageLog - log(tk));
    end
   
    [totalMetric, totalWeights] = managePixelOutliers(totalMetric,...
        totalWeights, imgStack{1});
    
    radianceMap = totalMetric ./ totalWeights;
end