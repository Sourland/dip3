function tonedImage = toneMapping(radianceMap , gamma)
%TONEMAPPING Summary of this function goes here
%   Detailed explanation goes here
    radianceMap = rescale(rescale(radianceMap).^gamma);
    tonedImage = ceil(255.*radianceMap);
end

