clc;
clear;
close all;

Ia1=imread('Results\cfrontal1.png');
Ib1=imread('Results\cleft1.png');
Ia = single(rgb2gray(Ia1)) ;
Ib = single(rgb2gray(Ib1)) ;
figure()
imshow(Ia1);
hold on
[fa, da] = vl_sift(Ia) ;
perm = randperm(size(fa,2)) ;
sel = perm(1:800) ;
h1 = vl_plotframe(fa(:,sel)) ;
h2 = vl_plotframe(fa(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
hold off

figure()
imshow(Ib1);
hold on
[fb, db] = vl_sift(Ib) ;
perm = randperm(size(fb,2)) ;
sel = perm(1:800) ;
h1 = vl_plotframe(fb(:,sel)) ;
h2 = vl_plotframe(fb(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
hold off


[matches, scores] = vl_ubcmatch(da, db) ;