clear all;
clc;
close all

addpath('Image1')
addpath('Image2')
imagefiles = dir('Image1/*.jpg');
totalFiles = length(imagefiles); 
global Zmin;
global Zmax;

Zmin = 0.05;
Zmax = 0.90;

for file=1:totalFiles
   currentfilename = imagefiles(file).name;
   currentimage = imread(currentfilename);
   imgStack{file} = im2double(currentimage);
end

t =  [1/2500, 1/1000, 1/500, 1/250, 1/125, 1/60, 1/30, 1/15, 1/8, 1/4, 1/2, 1, 2, 4, 8, 15];

[radianceMapRedUniform, radianceMapGreenUniform, radianceMapBlueUniform] = mergeLDRStack(imgStack, t, 'Uniform');
[radianceMapRedTent, radianceMapGreenTent, radianceMapBlueTent] = mergeLDRStack(imgStack, t, 'Tent');
[radianceMapRedGaussian, radianceMapGreenGaussian, radianceMapBlueGaussian] = mergeLDRStack(imgStack, t, 'Gaussian');
[radianceMapRedPhoton, radianceMapGreenPhoton, radianceMapBluePhoton] = mergeLDRStack(imgStack, t, 'Photon');

%% Plot Uniform HDR for each RGB Channel
figure()
imagesc(radianceMapRedUniform)
title('red')
colorbar
colormap hot

figure()
imagesc(radianceMapGreenUniform)
title('green')
colorbar
colormap summer

figure()
imagesc(radianceMapBlueUniform)
title('blue')
colorbar
colormap cool

%% Plot Tent HDR for each RGB Channel
figure()
imagesc(radianceMapRedTent)
title('red')
colorbar
colormap hot

figure()
imagesc(radianceMapGreenTent)
title('green')
colorbar
colormap summer

figure()
imagesc(radianceMapBlueTent)
title('blue')
colorbar
colormap cool

%% Plot Gaussian HDR for each RGB Channel
figure()
imagesc(radianceMapRedGaussian)
title('red')
colorbar
colormap hot

figure()
imagesc(radianceMapGreenGaussian)
title('green')
colorbar
colormap summer

figure()
imagesc(radianceMapBlueGaussian)
title('blue')
colorbar
colormap cool

%% Plot Photon HDR for each RGB Channel
figure()
imagesc(radianceMapRedPhoton)
title('red')
colorbar
colormap hot

figure()
imagesc(radianceMapGreenPhoton)
title('green')
colorbar
colormap summer

figure()
imagesc(radianceMapBluePhoton)
title('blue')
colorbar
colormap cool

