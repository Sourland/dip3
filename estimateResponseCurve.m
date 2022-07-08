function responseCurve = estimateResponseCurve(Z, exposureTimes, smoothingLamda, weights)
%ESTIMATERESPONSEFUNCTION Summary of this function goes here
%   Detailed explanation goes here
    n = 256;
    [noOfPixels, stackSize] = size(Z);
    A = zeros(noOfPixels*stackSize + n + 1, n + noOfPixels);
    b = zeros(size(A,1),1);
    %% Include the data−fitting equations
    tic
    k = 1;
    for i=1:noOfPixels
        for p=1:stackSize
            wip = weights(Z(i,p)+1);
            A(k,Z(i,p)+1) = wip; 
            A(k,n+i) = -wip; 
            b(k,1) = wip * log(exposureTimes(p));
            k=k+1;
        end
    end
    
    %% Fix the curve by setting its middle value to 0
    A(k,129) = 1;
    k=k+1;
    %% Include the smoothness equations
    for i=1:(n-2)
     A(k,i)=smoothingLamda*weights(i+1,1); 
     A(k,i+1)=-2*smoothingLamda*weights(i+1,1); 
     A(k,i+2)=smoothingLamda*weights(i+1,1);
     k=k+1;
    end
    toc
    %% Solve the system using SVD
    x = A\b
    responseCurve = x(1:n);
 
end

