function tonedImage = toneMapping(radianceMap , gamma)
%TONEMAPPING Summary of this function goes here
%   Detailed explanation goes here
    radianceMap = real(radianceMap.^gamma);
    radianceMap = (radianceMap - min(radianceMap(:)))./(max(radianceMap(:)) - min(radianceMap(:)));
    tonedImage = ceil(255.*radianceMap);
end

