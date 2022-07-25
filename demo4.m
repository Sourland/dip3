clear all;clc;close all
addpath('Image2');
addpath('src');

global Zmin;
global Zmax;

Zmin = -1e3;
Zmax = 1e3;

Z_red = [];
Z_green = [];
Z_blue = [];

imagefiles = dir('Image2/*.jpg');
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

    imgStackRed2{file} = currentimage(:,:,1);
    imgStackGreen2{file} = currentimage(:,:,2);
    imgStackBlue2{file} = currentimage(:,:,3);
    imgStack{file} = currentimage;

end

weightingFnc = 'TentCurve';

tk = [1/400, 1/250, 1/100, 1/40, 1/25, 1/8, 1/3];

lightLevels = 0:255;
figure()
tic
redReponseImage2 = estimateResponseCurve(Z_red, tk, 100, weightingFnc);
subplot(3,1,1)
hold on
title('Red Channel Response Curve')
grid on
plot(redReponseImage2, lightLevels, 'r')
toc

tic
greenReponseImage2 = estimateResponseCurve(Z_green, tk, 100, weightingFnc);
subplot(3,1,2)
hold on
title('Green Channel Response Curve')
grid on
plot(greenReponseImage2, lightLevels, 'g')
toc

tic
blueReponseImage2 = estimateResponseCurve(Z_blue, tk, 100, weightingFnc);
subplot(3,1,3)
hold on
title('Blue Channel Response Curve')
plot(blueReponseImage2, lightLevels, 'b')
grid on
toc

saveas(gcf,'demo4RESULTS/curve1.png')
radianceMapRed = mergeCalibratedLDRStack(imgStackRed2, tk, 'Tent', redReponseImage2);
figure()
imagesc(radianceMapRed)
colormap hot

radianceMapGreen = mergeCalibratedLDRStack(imgStackGreen2, tk, 'Tent', greenReponseImage2);
figure()
imagesc(radianceMapGreen)
colormap summer

radianceMapBlue = mergeCalibratedLDRStack(imgStackBlue2, tk, 'Tent', blueReponseImage2);
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


rotatedImg = imgStack{6};
imgStack(6) = [];
imgStackRed2(6) = [];
imgStackGreen2(6) = [];
imgStackBlue2(6) = [];

[optimizer, metric] = imregconfig('multimodal');

RotRed = rotatedImg(:,:,1);
RotGreen = rotatedImg(:,:,2);
RotBlue = rotatedImg(:,:,3);

Z_red = [];
Z_green = [];
Z_blue = [];

tform = imregtform(rgb2gray(imgStack{4}), rgb2gray(rotatedImg), 'rigid', optimizer, metric);
N = size(imgStack,2);
for file = 1:N
    imgStackRed2{file} = imwarp(imgStackRed2{file} , tform);
    imgStackGreen2{file} = imwarp(imgStackGreen2{file}, tform);
    imgStackBlue2{file} = imwarp(imgStackBlue2{file},tform);
    
    tempImage = imgStackRed2{file}(1:samplingRate:end, 1:samplingRate:end,:);
    [X, Y, ~] = size(tempImage);
    img = reshape(tempImage, [X*Y 1]);
    Z_red(:,file) = img;

    tempImage = imgStackGreen2{file}(1:samplingRate:end, 1:samplingRate:end,:);
    [X, Y, ~] = size(tempImage);
    img = reshape(tempImage, [X*Y 1]);
    Z_green(:,file) = img;

    tempImage = imgStackBlue2{file}(1:samplingRate:end, 1:samplingRate:end,:);
    [X, Y, ~] = size(tempImage);
    img = reshape(tempImage, [X*Y 1]);
    Z_blue(:,file) = img;

end

weightingFnc = 'TentCurve';

tk = [1/400, 1/250, 1/100, 1/40, 1/25, 1/3];

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
saveas(gcf,'demo4RESULTS/curves.png')

radianceMapRed = mergeCalibratedLDRStack(imgStackRed2, tk, 'Tent', redReponseImage2);
figure()
imagesc(radianceMapRed)
colormap hot

saveas(gcf,'demo4RESULTS/redtent.png')

radianceMapGreen = mergeCalibratedLDRStack(imgStackGreen2, tk, 'Tent', greenReponseImage2);
figure()
imagesc(radianceMapGreen)
colormap summer

saveas(gcf,'demo4RESULTS/greentent.png')

radianceMapBlue = mergeCalibratedLDRStack(imgStackBlue2, tk, 'Tent', blueReponseImage2);
figure()
imagesc(radianceMapBlue)
colormap bone

saveas(gcf,'demo4RESULTS/bluetent.png')

gamma = 0.7;
radianceMapRed = toneMapping(radianceMapRed, gamma);
radianceMapGreen = toneMapping(radianceMapGreen, gamma);
radianceMapBlue = toneMapping(radianceMapBlue, gamma);

HDRImageTent = cat(3, radianceMapRed, radianceMapGreen, radianceMapBlue);
figure()
imshow(HDRImageTent);
title('HDR Image, Tent, CALIBRATED EVEN MORE')

saveas(gcf,'demo4RESULTS/HDRtentULTRA.png')