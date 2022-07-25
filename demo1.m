clear all;
clc;
close all

addpath('Image1')
addpath('src');
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
figure()
imagesc(radianceMapRedUniform)
title('Uniform Red')
colorbar
colormap hot
saveas(gcf,'demo1RESULTS/reduni.png')

figure()
imagesc(radianceMapGreenUniform)
title('Uniform Green')
colorbar
colormap summer
saveas(gcf,'demo1RESULTS/greenuni.png')

figure()
imagesc(radianceMapBlueUniform)
title('Uniform Blue')
colorbar
colormap bone
saveas(gcf,'demo1RESULTS/blueuni.png')

%% Plot Tent HDR for each RGB Channel
figure()
imagesc(radianceMapRedTent)
title('red')
colorbar
colormap hot
saveas(gcf,'demo1RESULTS/redtent.png')

figure()
imagesc(radianceMapGreenTent)
title('green')
colorbar
colormap summer
saveas(gcf,'demo1RESULTS/greentent.png')

figure()
imagesc(radianceMapBlueTent)
title('blue')
colorbar
colormap bone
saveas(gcf,'demo1RESULTS/bluetent.png')

%% Plot Gaussian HDR for each RGB Channel
figure()
imagesc(radianceMapRedGaussian)
title('red')
colorbar
colormap hot
saveas(gcf,'demo1RESULTS/redgauss.png')

figure()
imagesc(radianceMapGreenGaussian)
title('green')
colorbar
colormap summer
saveas(gcf,'demo1RESULTS/greengauss.png')

figure()
imagesc(radianceMapBlueGaussian)
title('blue')
colorbar
colormap bone
saveas(gcf,'demo1RESULTS/bluegauss.png')

%% Plot Photon HDR for each RGB Channel
figure()
imagesc(radianceMapRedPhoton)
title('red')
colorbar
colormap hot
saveas(gcf,'demo1RESULTS/redphoton.png')

figure()
imagesc(radianceMapGreenPhoton)
title('green')
colorbar
colormap summer
saveas(gcf,'demo1RESULTS/greenphoton.png')

figure()
imagesc(radianceMapBluePhoton)
title('blue')
colorbar
colormap bone
saveas(gcf,'demo1RESULTS/bluephoton.png')
%% Plot Histograms
bins = 256;

figure();
subplot(4,3,1)
histogram(rescale(radianceMapRedUniform, 0, 255), bins)
title('Red Uniform Histogram')

subplot(4,3,2)
histogram(rescale(radianceMapGreenUniform, 0, 255), bins)
title('Green Uniform Histogram')

subplot(4,3,3)
histogram(rescale(radianceMapBlueUniform, 0, 255), bins)
title('Blue Uniform Histogram')

subplot(4,3,4)
histogram(rescale(radianceMapRedTent, 0, 255), bins)
title('Red Tent Histogram')

subplot(4,3,5)
histogram(rescale(radianceMapGreenTent, 0, 255), bins)
title('Green Tent Histogram')

subplot(4,3,6)
histogram(rescale(radianceMapBlueTent, 0, 255), bins)
title('Blue Tent Histogram')

subplot(4,3,7)
histogram(rescale(radianceMapRedGaussian, 0, 255), bins)
title('Red Gaussian Histogram')

subplot(4,3,8)
histogram(rescale(radianceMapGreenGaussian, 0, 255), bins)
title('Green Gaussian Histogram')

subplot(4,3,9)
histogram(rescale(radianceMapBlueGaussian, 0, 255), bins)
title('Blue Gaussian Histogram')

subplot(4,3,10)
histogram(rescale(radianceMapRedPhoton, 0, 255), bins)
title('Red Photon Histogram')

subplot(4,3,11)
histogram(rescale(radianceMapGreenPhoton, 0, 255), bins)
title('Green Photon Histogram')

subplot(4,3,12)
histogram(rescale(radianceMapBluePhoton, 0, 255), bins)
title('Blue Photon Histogram')
saveas(gcf,'demo1RESULTS/HISTOGRAM.png')