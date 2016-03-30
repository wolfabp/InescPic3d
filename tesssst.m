img1=rgb2gray(imread('imagemtest.png'));
img2=nonUniform(img1,8,7);
figure(72);
[counts,r] = imhist(img1);
stem(r,counts);
figure(73);
[counts,r] = imhist(img2);
stem(r,counts);