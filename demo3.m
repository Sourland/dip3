clear;clc;close all;
addpath('Image1');
addpath('Image2');
addpath('src');

global Zmin;
global Zmax;

Zmin = -1e3;
Zmax = 1e3;

Z_red = [];
Z_green = [];
Z_blue = [];


%% Image 1

imagefiles = dir('Image1/*.jpg');
imagefiles(1:16) = imagefiles([1 9:16 2:8]);
totalFiles = length(imagefiles); 

samplingRate = 64;
for file=1:totalFiles
    currentfilename = imagefiles(file).name;
    currentimage = imread(currentfilename);


   
    tempImage = currentimage(1:samplingRate:end, 1:samplingRate:end,:);
    [X, Y, ~] = size(tempImage);
    img = reshape(tempImage(:,:,1), [X*Y 1]);
    Z_red(:,file) = img;

    tempImage = currentimage(1:samplingRate:end, 1:samplingRate:end,:);
    [X, Y, ~] = size(tempImage);
    img = reshape(tempImage(:,:,2), [X*Y 1]);
    Z_green(:,file) = img;

    tempImage = currentimage(1:samplingRate:end, 1:samplingRate:end,:);
    [X, Y, ~] = size(tempImage);
    img = reshape(tempImage(:,:,3), [X*Y 1]);
    Z_blue(:,file) = img;

    imgStackRed1{file} = currentimage(:,:,1);
    imgStackGreen1{file} = currentimage(:,:,2);
    imgStackBlue1{file} = currentimage(:,:,3);
   
end

weightingFnc = 'TentCurve';

tk =  [1/2500, 1/1000, 1/500, 1/250, 1/125, 1/60, 1/30, ...
        1/15, 1/8, 1/4, 1/2, 1, 2, 4, 8, 15];

lightLevels = 0:255;
figure()
tic
redReponseImage1 = estimateResponseCurve(Z_red, tk, 100, weightingFnc);
subplot(1,3,1)
hold on
title('Red Channel Response Curve')
grid on
plot(redReponseImage1, lightLevels, 'r')
toc

tic
greenReponseImage1 = estimateResponseCurve(Z_green, tk, 100, weightingFnc);
subplot(1,3,2)
hold on
title('Green Channel Response Curve')
grid on
plot(greenReponseImage1, lightLevels, 'g')
toc

tic
blueReponseImage1 = estimateResponseCurve(Z_blue, tk, 100, weightingFnc);
subplot(1,3,3)
hold on
title('Blue Channel Response Curve')
plot(blueReponseImage1, lightLevels, 'b')
grid on
toc

radianceMapRed = mergeCalibratedLDRStack(imgStackRed1, tk, 'Tent', redReponseImage1);
figure()
imagesc(radianceMapRed)
colormap hot

radianceMapGreen = mergeCalibratedLDRStack(imgStackGreen1, tk, 'Tent', greenReponseImage1);
figure()
imagesc(radianceMapGreen)
colormap summer

radianceMapBlue = mergeCalibratedLDRStack(imgStackBlue1, tk, 'Tent', blueReponseImage1);
figure()
imagesc(radianceMapBlue)
colormap bone

gamma = 1.2;
radianceMapRed = toneMapping(radianceMapRed, gamma);
radianceMapGreen = toneMapping(radianceMapGreen, gamma);
radianceMapBlue = toneMapping(radianceMapBlue, gamma);

HDRImageTent = cat(3, radianceMapRed, radianceMapGreen, radianceMapBlue);
figure()
imshow(HDRImageTent);
title('HDR Image, Tent, CALIBRATED')

%% Image2

imagefiles = dir('Image2/*.jpg');
totalFiles = length(imagefiles); 

samplingRate = 64;

Z_red = [];
Z_green = [];
Z_blue = [];

for file=1:totalFiles
    currentfilename = imagefiles(file).name;
    currentimage = imread(currentfilename);

    tempImage = currentimage(1:samplingRate:end, 1:samplingRate:end,:);
    [X, Y, ~] = size(tempImage);
    img = reshape(tempImage(:,:,1), [X*Y 1]);
    Z_red(:,file) = img;

    tempImage = currentimage(1:samplingRate:end, 1:samplingRate:end,:);
    [X, Y, ~] = size(tempImage);
    img = reshape(tempImage(:,:,2), [X*Y 1]);
    Z_green(:,file) = img;

    tempImage = currentimage(1:samplingRate:end, 1:samplingRate:end,:);
    [X, Y, ~] = size(tempImage);
    img = reshape(tempImage(:,:,3), [X*Y 1]);
    Z_blue(:,file) = img;
   
    imgStackRed2{file} = currentimage(:,:,1);
    imgStackGreen2{file} = currentimage(:,:,2);
    imgStackBlue2{file} = currentimage(:,:,3);
end

weightingFnc = 'TentCurve';

tk = [1/400, 1/250, 1/100, 1/40, 1/25, 1/8, 1/3];

lightLevels = 0:255;
figure()
tic
redReponseImage2 = estimateResponseCurve(Z_red, tk, 100, weightingFnc);
subplot(1,3,1)
hold on
title('Red Channel Response Curve')
grid on
plot(redReponseImage2, lightLevels, 'r')
toc

tic
greenReponseImage2 = estimateResponseCurve(Z_green, tk, 100, weightingFnc);
subplot(1,3,2)
hold on
title('Green Channel Response Curve')
grid on
plot(greenReponseImage2, lightLevels, 'g')
toc

tic
blueReponseImage2 = estimateResponseCurve(Z_blue, tk, 100, weightingFnc);
subplot(1,3,3)
hold on
title('Blue Channel Response Curve')
plot(blueReponseImage2, lightLevels, 'b')
grid on
toc

radianceMapRed = mergeCalibratedLDRStack(imgStackRed2, tk, 'Tent', redReponseImage1);
figure()
imagesc(radianceMapRed)
colormap hot

radianceMapGreen = mergeCalibratedLDRStack(imgStackGreen2, tk, 'Tent', greenReponseImage1);
figure()
imagesc(radianceMapGreen)
colormap summer

radianceMapBlue = mergeCalibratedLDRStack(imgStackBlue2, tk, 'Tent', blueReponseImage1);
figure()
imagesc(radianceMapBlue)
colormap bone

gamma = 0.7;
radianceMapRed = toneMapping(radianceMapRed, gamma);
radianceMapGreen = toneMapping(radianceMapGreen, gamma);
radianceMapBlue = toneMapping(radianceMapBlue, gamma);

HDRImageTent = cat(3, radianceMapRed, radianceMapGreen, radianceMapBlue);
figure()
imshow(HDRImageTent);
title('HDR Image, Tent, CALIBRATED')