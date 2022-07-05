clear;clc;close all;
addpath('Image1')

imagefiles = dir('Image1/*.jpg');
imagefiles(1:16) = imagefiles([1 9:16 2:8]);
totalFiles = length(imagefiles); 
global Zmin;
global Zmax;

Zmin = 0.05;
Zmax = 0.95;

for file=1:totalFiles
   currentfilename = imagefiles(file).name;
   currentimage = imread(currentfilename);
   imgStackRed{file} = im2double(currentimage(:,:,1));
   imgStackGreen{file} = im2double(currentimage(:,:,2));
   imgStackBlue{file} = im2double(currentimage(:,:,3));
end

t =  [1/2500, 1/1000, 1/500, 1/250, 1/125, 1/60, 1/30, 1/15, 1/8, 1/4, 1/2, 1, 2, 4, 8, 15];

%gamma = 0.8;
gamma = 1;
%% Get the radiance maps
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

%% Apply tone mapping
radianceMapRedUniform = toneMapping(radianceMapRedUniform, gamma);
radianceMapGreenUniform = toneMapping(radianceMapGreenUniform, gamma);
radianceMapBlueUniform = toneMapping(radianceMapBlueUniform, gamma);

radianceMapRedTent = toneMapping(radianceMapRedTent, gamma);
radianceMapGreenTent = toneMapping(radianceMapGreenTent, gamma);
radianceMapBlueTent = toneMapping(radianceMapBlueTent, gamma);

radianceMapRedGaussian = toneMapping(radianceMapRedGaussian, gamma);
radianceMapGreenGaussian = toneMapping(radianceMapGreenGaussian, gamma);
radianceMapBlueGaussian = toneMapping(radianceMapBlueGaussian, gamma);

radianceMapRedPhoton = toneMapping(radianceMapRedPhoton, gamma);
radianceMapGreenPhoton = toneMapping(radianceMapGreenPhoton, gamma);
radianceMapBluePhoton = toneMapping(radianceMapBluePhoton, gamma);

HDRImageUniform = cat(3, radianceMapRedUniform, radianceMapGreenUniform, radianceMapBlueUniform);
figure()
imshow(HDRImageUniform);
title('HDR Image, Uniform')

HDRImageTent = cat(3, radianceMapRedTent, radianceMapGreenTent, radianceMapBlueTent);
figure()
imshow(HDRImageTent);
title('HDR Image, Tent')

HDRImageGaussian = cat(3, radianceMapRedGaussian, radianceMapGreenGaussian, radianceMapBlueGaussian);
figure()
imshow(HDRImageGaussian);
title('HDR Image, Gaussian')

HDRImagePhoton = cat(3, radianceMapRedPhoton, radianceMapGreenPhoton, radianceMapBluePhoton);
figure()
imshow(HDRImagePhoton);
title('HDR Image, Photon')

grayPalettePosition = [250 1350; 300 1350; 350 1350; 400 1350; 450 1350; 500 1350];

grayImageUniform = rgb2gray(HDRImageUniform);
grayImageTent = rgb2gray(HDRImageTent);
grayImageGaussian = rgb2gray(HDRImageGaussian);
grayImagePhoton = rgb2gray(HDRImagePhoton);

pixelsUniform = zeros(6,2);
pixelsTent = zeros(6,2);
pixelsGaussian = zeros(6,2);
pixelsPhoton = zeros(6,2);

for i = 1:6
    pixelsUniform(i,2) = grayImageUniform(grayPalettePosition(i,1), grayPalettePosition(i,2));
    pixelsUniform(i,1) = i;
    
    pixelsTent(i,2) = grayImageTent(grayPalettePosition(i,1), grayPalettePosition(i,2));
    pixelsTent(i,1) = i;
    
    pixelsGaussian(i,2) = grayImageGaussian(grayPalettePosition(i,1), grayPalettePosition(i,2));
    pixelsGaussian(i,1) = i;
    
    pixelsPhoton(i,2) = grayImagePhoton(grayPalettePosition(i,1), grayPalettePosition(i,2));
    pixelsPhoton(i,1) = i;
end
pixelsUniform(:,2)
pixelsTent(:,2)
pixelsGaussian(:,2)
pixelsPhoton(:,2)

figure()
hold on

subplot(2,2,1)
scatter(pixelsUniform(:,1), pixelsUniform(:,2))
xlim([0 10]);
hold on
plot(pixelsUniform(:,1), pixelsUniform(:,2), 'c-','LineWidth', 1.2)
plot([pixelsUniform(1,1), pixelsUniform(6,1)], [pixelsUniform(1,2), pixelsUniform(6,2)], '-r','LineWidth',2)
legend('Pixel values', 'Point-connecting line', 'Line')
xlabel('Number of Pixel')
ylabel('Light Intensity')
title('Uniform Pixel Gray Values')
grid on

subplot(2,2,2)
scatter(pixelsTent(:,1), pixelsTent(:,2))
xlim([0 10]);
hold on
plot(pixelsTent(:,1), pixelsTent(:,2), 'c-', 'LineWidth', 1.2)
plot([pixelsTent(1,1), pixelsTent(6,1)], [pixelsTent(1,2), pixelsTent(6,2)], '-r','LineWidth',2)
legend('Pixel values', 'Point-connecting line', 'Line')
xlabel('Number of Pixel')
ylabel('Light Intensity')
title('Tent Pixel Gray Values')
grid on

subplot(2,2,3)
scatter(pixelsGaussian(:,1), pixelsGaussian(:,2))
xlim([0 10]);
hold on
plot(pixelsGaussian(:,1), pixelsGaussian(:,2), 'c-', 'LineWidth', 1.2)
plot([pixelsGaussian(1,1), pixelsGaussian(6,1)], [pixelsGaussian(1,2), pixelsGaussian(6,2)], '-r','LineWidth',2)
legend('Pixel values', 'Point-connecting line', 'Line')
xlabel('Number of Pixel')
ylabel('Light Intensity')
title('Gaussian Pixel Gray Values')
grid on

subplot(2,2,4)
scatter(pixelsPhoton(:,1), pixelsPhoton(:,2))
xlim([0 10]);
hold on
plot(pixelsPhoton(:,1), pixelsPhoton(:,2), 'c-', 'LineWidth', 1.2)
plot([pixelsPhoton(1,1), pixelsPhoton(6,1)], [pixelsPhoton(1,2), pixelsPhoton(6,2)], '-r','LineWidth',2)
legend('Pixel values', 'Point-connecting line', 'Line')
xlabel('Number of Pixel')
ylabel('Light Intensity')
title('Photon Pixel Gray Values')
grid on


