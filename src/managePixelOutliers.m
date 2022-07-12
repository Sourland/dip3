function [totalMetric, totalWeights] = managePixelOutliers(totalMetric, totalWeights, image)
%MANAGEPIXELOUTLIERS Summary of this function goes here
%   Detailed explanation goes here
    global Zmin;
    global Zmax;
    
    deadPixels = totalWeights == 0;
    
    overexposedPixels = (deadPixels & image > Zmax);
    underexposedPixels = (deadPixels & image < Zmin);
    
    totalWeights(deadPixels) = 1;
    
    totalMetric(deadPixels) = -1e-3;
    
    
    if sum(overexposedPixels, 'all') > 0
        totalMetric(overexposedPixels) = max(totalMetric(:));
    end
    
    if sum(underexposedPixels, 'all') > 0
        lowest = totalMetric(totalMetric > -1e-3);
        totalMetric(underexposedPixels) = min(lowest(:));
    end
    
    
      
end

