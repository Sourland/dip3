clear;clc;close all;
addpath('Image1')

imagefiles = dir('Image1/*.jpg');
imagefiles(1:16) = imagefiles([1 9:16 2:8]);
totalFiles = length(imagefiles); 

global Zmin;
global Zmax;

Zmin = 0.05;
Zmax = 0.99;

Z_red = [];
Z_green = [];
Z_blue = [];

samplingRate = 32;

for file=1:totalFiles
   currentfilename = imagefiles(file).name;
   currentimage = imread(currentfilename);
   currentimage = currentimage(1:samplingRate:end, 1:samplingRate:end,:);
   [X, Y, ~] = size(currentimage);
   
   img = reshape(currentimage(:,:,1), [X*Y 1]);
   Z_red(:,file) = img;
   
   img = reshape(currentimage(:,:,2), [X*Y 1]);
   Z_green(:,file) = img;
   
   img = reshape(currentimage(:,:,3), [X*Y 1]);
   Z_blue(:,file) = img;

end

tk =  [1/2500, 1/1000, 1/500, 1/250, 1/125, 1/60, 1/30, 1/15, 1/8, 1/4, 1/2, 1, 2, 4, 8, 15];

w_red = [];
for k=1:totalFiles
    w_red(:,k) = weightingFunction(im2double(mat2gray(Z_red(:,k))), tk(k), 'Gaussian');
end

w_green = [];
for k=1:totalFiles
    w_green(:,k) = weightingFunction(im2double(mat2gray(Z_green(:,k))), tk(k), 'Gaussian');
end

w_blue = [];
for k=1:totalFiles
    w_blue(:,k) = weightingFunction(im2double(mat2gray(Z_blue(:,k))), tk(k), 'Gaussian');
end

lightLevels = 0:255;

tic
redReponse = estimateResponseCurve(Z_red, tk, 2, w_red);
figure()
grid on
plot(redReponse, lightLevels)
toc

tic
greenReponse = estimateResponseCurve(Z_green, tk, 2, w_green);
figure()
grid on
plot(greenReponse, lightLevels)
toc

tic
blueReponse = estimateResponseCurve(Z_blue, tk, 2, w_blue);
figure()
grid on
plot(blueReponse, lightLevels)
toc

