function w = weightingFunction(z, tk, option)
%WEIGHTINGFUNCTION Summary of this function goes here
%   Detailed explanation goes here
    global Zmin;
    global Zmax;
    [X, Y, ~] = size(z);
    outsiders = (z < Zmin | z > Zmax);
    w = zeros(X, Y);

    if strcmp(option, 'Uniform')
        w = ones(X,Y);
    elseif strcmp(option, 'Tent')
        w = min(z, 1-z);
     elseif strcmp(option, 'TentCurve')
        w = min(z, 255-z);
    elseif strcmp(option, 'Gaussian')
        t = 4 / (0.5)^2;
        w = exp(-t .* (z - 0.5).^2);
    elseif strcmp(option, 'Photon')
        w = tk * ones(X,Y);
    end        
    
    w(outsiders) = 0;
end