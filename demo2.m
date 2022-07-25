clear;clc;close all;
addpath('Image1')
addpath('src');
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

gamma1 = 0.8;
gamma2 = 1.4;
my_gamma = 1.21;

gamma = 1;
% Get the radiance maps
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

% Apply tone mapping
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
imwrite(HDRImageUniform,append('demo2RESULTS/hdruni-gamma', num2str(gamma), '.png'))

HDRImageTent = cat(3, radianceMapRedTent, radianceMapGreenTent, radianceMapBlueTent);
figure()
imshow(HDRImageTent);
title('HDR Image, Tent')
imwrite(HDRImageTent,append('demo2RESULTS/hdrtent-gamma', num2str(gamma), '.png'))

HDRImageGaussian = cat(3, radianceMapRedGaussian, radianceMapGreenGaussian, radianceMapBlueGaussian);
figure()
imshow(HDRImageGaussian);
title('HDR Image, Gaussian')
imwrite(HDRImageGaussian,append('demo2RESULTS/hdrgauss-gamma', num2str(gamma), '.png'))

HDRImagePhoton = cat(3, radianceMapRedPhoton, radianceMapGreenPhoton, radianceMapBluePhoton);
figure()
imshow(HDRImagePhoton);
title('HDR Image, Photon')
imwrite(HDRImagePhoton,append('demo2RESULTS/hdrphoton-gamma', num2str(gamma), '.png'))

grayPalettePosition = [250 1350; 300 1350; 350 1350; 400 1350; 450 1350; 500 1350];

grayImageGaussian = rgb2gray(HDRImageGaussian);

pixelsGaussian = zeros(6,2);

for i = 1:6
    pixelsGaussian(i,2) = grayImageGaussian(grayPalettePosition(i,1), grayPalettePosition(i,2));
    pixelsGaussian(i,1) = i;
end
pixelsGaussian(:,2)

figure()
hold on

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

