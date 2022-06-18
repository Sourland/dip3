function w = weightingFunction(z, tk, option)
%WEIGHTINGFUNCTION Summary of this function goes here
%   Detailed explanation goes here
    global Zmin;
    global Zmax;
    [X, Y, ~] = size(z);
    w = zeros(X, Y);
    for x = 1:X
        for y = 1:Y
            if z(x,y) >= Zmin && z(x,y) <= Zmax
               if strcmp(option, 'uniform')
                    w(x,y) = 1;
                elseif strcmp(option, 'tent')
                    w(x,y) = min(z(x,y), 1-z(x,y));
                elseif strcmp(option, 'Guassian')
                    t = 0.5;
                    w(x,y) = exp(-4 * (z(x,y) - t)^2 / t^2);
                elseif strcmp(option, 'photon')
                    w(x,y) = tk;
               end
            else
            
                w(x,y) = 0;        
            end
        end
    end
 
end