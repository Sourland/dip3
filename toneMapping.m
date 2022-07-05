function tonedImage = toneMapping(radianceMap , gamma)
%TONEMAPPING Summary of this function goes here
%   Detailed explanation goes here
    radianceMap = rescale(rescale(radianceMap).^gamma, 0, 255);
    tonedImage = uint8(radianceMap);
end

