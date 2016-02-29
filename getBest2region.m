function [img4,img5] = getBest2region(img3)
    figure(3);
    [counts,r] = imhist(img3);
    stem(r,counts);
    a=1;
    for posi=1:256
        if(counts(posi)>0)
            a=posi-1;
            break;
        end
    end
        
    [M,N]=size(img3);
    img4=zeros(M,N);
    for u=1:M
        for v=1:N
            if(img3(u,v)==a)
                img4(u,v)=255;
            end
        end
    end
    
    b=1;
    for posi2=a+2:256
        if(counts(posi2)>0)
            b=posi2-1;
            break;
        end
    end
    img5=zeros(M,N);
    for u=1:M
        for v=1:N
            if(img3(u,v)==b)
                img5(u,v)=255;
            end
        end
    end
    
    conn=8;
    [L, num] = bwlabel(img4, conn);
    [L2, num2] = bwlabel(img5, conn);
    
    area=zeros(num);
    for r=1:num
        area(r) = bwarea(L==r);
    end
    area=area(:,1);
    [maxi,I] = max(area);
    img4=zeros(M,N);
    for u=1:M
        for v=1:N
            if(L(u,v)==I)
                img4(u,v)=255;
            end
        end
    end
    area2=zeros(num2);
    for r=1:num2
        area2(r) = bwarea(L2==r);
    end
    area2=area2(:,1);
    [maxi2,I2] = max(area2);
    img5=zeros(M,N);
    for u=1:M
        for v=1:N
            if(L2(u,v)==I2)
                img5(u,v)=255;
            end
        end
    end
end