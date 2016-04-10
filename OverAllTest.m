tic
clc;
clear;
close all;
% testMultiPos3;
% testseg2;
% system('teste1.exe 0 cfrontal1.PNG segment.PNG');
[img1,img2]=getLatSeg('dright1.png',0,1);
figure();
imshow(img1);
figure();
imshow(img2);
[img1,img2]=getLatSeg('dleft2.png',0,1);
figure();
imshow(img1);
figure();
imshow(img2);
toc