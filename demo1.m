clear all;clc;close all

addpath('Image1')
addpath('Image2')
imagefiles = dir('Image1/*.jpg');
totalFiles = length(imagefiles); 
global Zmin;
global Zmax;

Zmin = 0.01;
Zmax = 0.99;

for file=1:totalFiles
   currentfilename = imagefiles(file).name;
   currentimage = imread(currentfilename);
   imgStack{file} = double(currentimage)./255;
end

t =  [1/2500, 1/1000, 1/500, 1/250, 1/125, 1/60, 1/30, 1/15, 1/8, 1/4, 1/2, 1, 2, 4, 8, 15];

tic
radianceMapUniform = mergeLDRStack(imgStack, t, 'uniform');
figure();
imshow(radianceMapUniform);
toc

tic
radianceMapTent = mergeLDRStack(imgStack, t, 'tent');
figure();
imshow(radianceMapTent);
toc

tic
radianceMapGaussian = mergeLDRStack(imgStack, t, 'Gaussian');
figure();
imshow(radianceMapGaussian);
toc

tic
radianceMapPhoton = mergeLDRStack(imgStack, t, 'photon');
figure();
imshow(radianceMapPhoton);
toc
toc

