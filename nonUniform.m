function[imgOut]=nonUniform(I,n,p)


K=2^(n-p);

kClusters=zeros(K);
kClustersOld=kClusters;
[M,N]=size(I);
imgOut=uint8(zeros(M,N));

[counts,binLocations] = imhist(I);
% figure();
% stem(imhist(I));

maxI=(2^n)-1;

regianSpace=(maxI/K);

%Valores de klusters iniciais
for i=1:K
    kClusters(i)=floor(regianSpace*i);
end
tamanho=max(size(counts));
clusters=zeros(tamanho,2);
clusters(1:tamanho,1)=counts(1:tamanho);

while 1<2
    
    kClustersOld=kClusters;
    %atribuir o k mais proximo de um ponto
    a=1;
    for i=1:tamanho
        minimo=255;
        for y=1:K
            mini=abs((i-1)-kClusters(y));
            if(mini<minimo)
                minimo=mini;
                a=y;
            end
        end
        clusters(i,2)=a;
    end
        
    l=1;
    %ver medias dos pontos para K e calcular o novo k
    for i=1:K
        soma=0;
        somaTotal=0;
        while l<tamanho
            if(clusters(l,2)==i)
                soma=clusters(l,1)*(l-1)+soma;
                somaTotal=somaTotal+clusters(l,1);
            else
                break;
            end
            l=l+1;
        end
        
        
        if(somaTotal==0 && i==1)
            kClusters(i)=0;
        else
            if(somaTotal==0 && i~=0)
                kClusters(i)=kClusters(i);
            else
                kClusters(i)=soma/somaTotal;
            end
        end
    end
    if((kClusters)==(kClustersOld))
        break;
    end
end;

%Quantizar a imagem de entrada com os valores dos klusters
for x=1:M
    for y=1:N
        imgOut(x,y)=round(kClusters(clusters(I(x,y)+1,2)));
    end
end

end
