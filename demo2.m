clear;clc;close all;
addpath('Image1')

imagefiles = dir('Image1/*.jpg');
imagefiles(1:16) = imagefiles([1 9:16 2:8]);
totalFiles = length(imagefiles); 
global Zmin;
global Zmax;

Zmin = 0.05;
Zmax = 0.90;

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

radianceMapRedUniform = toneMapping(radianceMapRedUniform, gamma2);
radianceMapGreenUniform = toneMapping(radianceMapGreenUniform, gamma2);
radianceMapBlueUniform = toneMapping(radianceMapBlueUniform, gamma2);

radianceMapRedTent = toneMapping(radianceMapRedTent, gamma2);
radianceMapGreenTent = toneMapping(radianceMapGreenTent, gamma2);
radianceMapBlueTent = toneMapping(radianceMapBlueTent, gamma2);

radianceMapRedGaussian = toneMapping(radianceMapRedGaussian, gamma2);
radianceMapGreenGaussian = toneMapping(radianceMapGreenGaussian, gamma2);
radianceMapBlueGaussian = toneMapping(radianceMapBlueGaussian, gamma2);

radianceMapRedPhoton = toneMapping(radianceMapRedPhoton, gamma2);
radianceMapGreenPhoton = toneMapping(radianceMapGreenPhoton, gamma2);
radianceMapBluePhoton = toneMapping(radianceMapBluePhoton, gamma2);

HDRImageUniform = cat(3, radianceMapRedUniform, radianceMapGreenUniform, radianceMapBlueUniform);
figure()
imagesc(HDRImageUniform);

HDRImageTent = cat(3, radianceMapRedTent, radianceMapGreenTent, radianceMapBlueTent);
figure()
imagesc(HDRImageTent);

HDRImageGaussian = cat(3, radianceMapRedGaussian, radianceMapGreenGaussian, radianceMapBlueGaussian);
figure()
imagesc(HDRImageGaussian);

HDRImagePhoton = cat(3, radianceMapRedPhoton, radianceMapGreenPhoton, radianceMapBluePhoton);
figure()
imagesc(HDRImagePhoton);