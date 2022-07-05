clear all;
clc;
close all

addpath('Image1')
addpath('Image2')
imagefiles = dir('Image1/*.jpg');
imagefiles(1:16) = imagefiles([1 9:16 2:8]);
totalFiles = length(imagefiles); 
global Zmin;
global Zmax;

Zmin = 0.01;
Zmax = 0.99;

for file=1:totalFiles
   currentfilename = imagefiles(file).name;
   currentimage = imread(currentfilename);
   imgStackRed{file} = im2double(currentimage(:,:,1));
   imgStackGreen{file} = im2double(currentimage(:,:,2));
   imgStackBlue{file} = im2double(currentimage(:,:,3));
end
t =  [1/2500, 1/1000, 1/500, 1/250, 1/125, 1/60, 1/30, 1/15, 1/8, 1/4, 1/2, 1, 2, 4, 8, 15];

radianceMapRedUniform = mergeLDRStack(imgStackRed, t, 'Uniform');
radianceMapGreenUniform = mergeLDRStack(imgStackGreen, t, 'Uniform');
radianceMapBlueUniform = mergeLDRStack(imgStackBlue, t, 'Uniform');

radianceMapRedTent = mergeLDRStack(imgStackRed, t, 'Tent');
radianceMapGreenTent = mergeLDRStack(imgStackGreen, t, 'Tent');
radianceMapBlueTent = mergeLDRStack(imgStackBlue, t, 'Tent');

radianceMapRedGaussian = mergeLDRStack(imgStackRed, t, 'Gaussian');
radianceMapGreenGaussian = mergeLDRStack(imgStackGreen, t, 'Gaussian');
radianceMapBlueGaussian = mergeLDRStack(imgStackBlue, t, 'Gaussian');

radianceMapRedPhoton = mergeLDRStack(imgStackRed, t, 'Photon');
radianceMapGreenPhoton = mergeLDRStack(imgStackGreen, t, 'Photon');
radianceMapBluePhoton = mergeLDRStack(imgStackBlue, t, 'Photon');

%% Plot Uniform HDR for each RGB Channel
% figure()
% imagesc(radianceMapRedUniform)
% title('Uniform Red')
% colorbar
% colormap hot
% 
% figure()
% imagesc(radianceMapGreenUniform)
% title('Uniform Green')
% colorbar
% colormap summer
% 
% figure()
% imagesc(radianceMapBlueUniform)
% title('Uniform Blue')
% colorbar
% colormap gray

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
colormap gray

% %% Plot Gaussian HDR for each RGB Channel
% figure()
% imagesc(radianceMapRedGaussian)
% title('red')
% colorbar
% colormap gray
% 
% figure()
% imagesc(radianceMapGreenGaussian)
% title('green')
% colorbar
% colormap gray
% 
% figure()
% imagesc(radianceMapBlueGaussian)
% title('blue')
% colorbar
% colormap gray
% 
% %% Plot Pgrayon HDR for each RGB Channel
% figure()
% imagesc(radianceMapRedPhoton)
% title('red')
% colorbar
% colormap gray
% 
% figure()
% imagesc(radianceMapGreenPhoton)
% title('green')
% colorbar
% colormap gray
% 
% figure()
% imagesc(radianceMapBluePhoton)
% title('blue')
% colorbar
% colormap gray

