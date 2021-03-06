function [img2] = getQuantizedRegions(img1,nCent)

thresh=multithresh(img1,nCent);
[counts,r] = imhist(img1);
centroids=zeros(nCent+1,1);
thre=zeros(nCent+2,1);
thre(2:nCent+1)=thresh;
thre(nCent+2)=255;
thre(1)=0;
figure();
stem([counts]);
for j=1: (nCent+1)
    cont1=0;
    cont2=0;
    for i=(thre(j)+1):thre(j+1)
        cont1=counts(i)*i+cont1;
        cont2=counts(i)+cont2;
    end;
    a=(cont1/cont2)
    centroids(j)=a-1;
end
centroids=uint8(round(sort(centroids)));
centroids=sort(centroids);
img2=imquantize(img1,centroids);

[M,N]=size(img1);
for i=1:M
    for j=1:N
        img2(i,j)=centroids(img2(i,j));
    end
end

end