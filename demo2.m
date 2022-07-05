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
   imgStack{file} = im2double(currentimage);
end

t =  [1/2500, 1/1000, 1/500, 1/250, 1/125, 1/60, 1/30, 1/15, 1/8, 1/4, 1/2, 1, 2, 4, 8, 15];

gamma1 = 0.8;
gamma2 = 1.4;

[radianceMapRedUniform, radianceMapGreenUniform, radianceMapBlueUniform] = mergeLDRStack(imgStack, t, 'Uniform');
[radianceMapRedTent, radianceMapGreenTent, radianceMapBlueTent] = mergeLDRStack(imgStack, t, 'Tent');
[radianceMapRedGaussian, radianceMapGreenGaussian, radianceMapBlueGaussian] = mergeLDRStack(imgStack, t, 'Gaussian');
[radianceMapRedPhoton, radianceMapGreenPhoton, radianceMapBluePhoton] = mergeLDRStack(imgStack, t, 'Photon');

radianceMapRedUniform = toneMapping(radianceMapRedUniform, gamma1);
radianceMapGreenUniform = toneMapping(radianceMapGreenUniform, gamma1);
radianceMapBlueUniform = toneMapping(radianceMapBlueUniform, gamma1);

radianceMapRedTent = toneMapping(radianceMapRedTent, gamma1);
radianceMapGreenTent = toneMapping(radianceMapGreenTent, gamma1);
radianceMapBlueTent = toneMapping(radianceMapBlueTent, gamma1);

radianceMapRedGaussian = toneMapping(radianceMapRedGaussian, gamma1);
radianceMapGreenGaussian = toneMapping(radianceMapGreenGaussian, gamma1);
radianceMapBlueGaussian = toneMapping(radianceMapBlueGaussian, gamma1);

radianceMapRedPhoton = toneMapping(radianceMapRedPhoton, gamma1);
radianceMapGreenPhoton = toneMapping(radianceMapGreenPhoton, gamma1);
radianceMapBluePhoton = toneMapping(radianceMapBluePhoton, gamma1);

HDRImageUniform = cat(3, radianceMapRedUniform, radianceMapGreenUniform, radianceMapBlueUniform);
figure()
imshow(HDRImageUniform);

HDRImageTent = cat(3, radianceMapRedTent, radianceMapGreenTent, radianceMapBlueTent);
figure()
imshow(HDRImageTent);

HDRImageGaussian = cat(3, radianceMapRedGaussian, radianceMapGreenGaussian, radianceMapBlueGaussian);
figure()
imshow(HDRImageGaussian);

HDRImagePhoton = cat(3, radianceMapRedPhoton, radianceMapGreenPhoton, radianceMapBluePhoton);
figure()
imshow(HDRImagePhoton);