function [posL1,posF1,posR1,posL2,posF2,posR2]= SelectViews(s1,plotOption)
    %% Select Options
    code=0;
    %% Got to folder + check calib + get pairs list    
    localresults=strcat(s1,'Results\');
    k = strfind(s1,'\DadosTese\');
    tam=size('\DadosTese\',2);
    tam2=size(s1,2);
    subs1=s1((tam+k):tam2);
    k1 = strfind(subs1,'\');
    subs2=subs1(1:k1(1));
    local=strcat(s1(1:tam+k+size(subs2,2)-1),'calib\');
    MyDirInfo = dir(local);
    filenames= cell(size(MyDirInfo,2)-2,1);
    filenames{1}=[MyDirInfo(3).('name')];
    if(strfind(filenames{1},'Lisbon')>0)
        code=1;
    else
        if(strfind(filenames{1},'London')>0)
            code=2;
        else
            if(strfind(filenames{1},'Leiden')>0)
                code=3;
            end
        end
    end
    %%
    tic
    fileID = fopen(strcat(s1,'DataMatchNames.txt'));
    names =textscan(fileID,'%s %s');
    tamanho=max(size(names{1,1}));
    measurements=zeros(tamanho,5);
    simetria=zeros(tamanho,1);

    for i=1:tamanho
    %% Scan images and get features
        %get name & read depth image
        str=names{1,2}{i,1};
        try
            img=imread(strcat(s1,str));
        catch
            measurements(i,2)=0;
            simetria(i)=0;
            continue
        end

        %change scale & seperate the body from 
        img2=uint8(img./8);
        imgnovo=im2bw(img2,graythresh(img2));    
        img14=uint8(times(double(img2),~imgnovo)+imgnovo*255);
%         figure(10)
%         imshow(img14);
%         I=double(img14);
%         [IDX2, C2] = kmeans(I(:),16);
%         J2=reshape(IDX2,size(img14));
%         img3=uint8(round(C2(J2(:,:))));
        img3=nonUniform(img14,8,4);
    %         figure(12)
    %     imshow(img3);
    %         figure(13);
    %     stem(imhist(img3));
    %     pause();

        %[img4] = getBestRegion(img3);
        [img4,img5] = getBest2region(img3);
        img4=uint8((img4*(3/4))+(img5*(1/4)));
    %%%     figure(14);
    %%%     imshow(img4);
        img4=im2bw(img4);
        s=regionprops(img4,'Area','BoundingBox');
        measurements(i,2)=s(1).Area;
        %% simetria
        bbox=s(1).BoundingBox;
        bbox=floor(bbox);
        w=round(bbox(3)/2.0);
        x=bbox(2);
        if(bbox(2)==0)
            bbox(2)=bbox(2)+1;
            x=0;
        end;
        y=bbox(1);
        if(bbox(1)==0)
            bbox(1)=bbox(1)+1;
            y=0;
        end;
        crop1=img4(bbox(2):(x+bbox(4)),bbox(1):(y+w));
        crop2=img4(bbox(2):(x+bbox(4)),(bbox(1)+w):y+bbox(3));
        invCrop2=flip(crop2 ,2);
        count1=0;
        count2=0;
        for v=1:w
            for u=1:bbox(4)
                if(crop1(u,v)==1 || invCrop2(u,v)==1 )
                    count1=count1+1;
                end
                if(crop1(u,v)==1 && invCrop2(u,v)==1 )
                    count2=count2+1;
                end
            end
        end
        simetria(i)=count2*100.0/count1;
    end


    %% Select Final frontal view depth and color image

    % Analyse simetry
    h=fspecial('gaussian',[1 100],10);
    simet=imfilter(simetria(:),h');
%     simet=smooth(simetria(:),0.07,'moving');
    media=mean(simetria);
    if(plotOption==1)
        figure(50);
        plot(1:1:tamanho,simetria,'-o');
        hold on
        plot(1:1:tamanho,media,'g');
        h1=plot(simet,'r');
        hold off
        saveas(h1,strcat(localresults,'simtetria.png'));
        close 50;
    end
    [maxtab3, mintab3]=peakdet(simet, 30);
    mode1='peaks';
    mode2='troughs';
    dim=1;
    npts=round(tamanho*0.15);
    [Vo1,Io1] = pickpeaks(simet,npts,dim,mode1);
    [Vo2,Io2] = pickpeaks(simet,npts,dim,mode2);
        if(code==1)
            posfrontal2=min([Io1(1),Io1(2),Io1(3)]);
        else
            if(size(Io1)==1)
                posfrontal2=Io1(1);
            else
                a=abs((Io1(1))-(tamanho/2));
                b=abs((Io1(2))-(tamanho/2));
                if(a<b)
                    posfrontal2=Io1(1);
                else
                    posfrontal2=Io1(2);
                end
            end
        end
        imwrite(imread(strcat(s1,names{1,1}{posfrontal2,1})),strcat(localresults,'cfrontal1_sim.png'));
        imwrite(imread(strcat(s1,names{1,2}{posfrontal2,1})),strcat(localresults,'dfrontal1_sim.png'));
        posF2=posfrontal2;
    %%
    h=fspecial('gaussian',[1 100],10);
    measurements(:,2)=imfilter(measurements(:,2),h');
%         measurements(:,2)=smooth(measurements(:,2),0.05,'moving');
    valormedio=mean(measurements(:,2));
    if(plotOption==1)
        figure(20);
        hold on;
%         arraymedio=zeros(tamanho);
%         arraymedio(:)=valormedio;
        plot(1:1:tamanho,valormedio);
        h2=plot(1:1:tamanho,measurements(:,2),'o-');
        hold off;
        saveas(h2,strcat(localresults,'area.png'));
        close 20;
    end;
    if(~(code==1))
        npts=round(tamanho*0.2);
        [Vo3,Io3] = pickpeaks(simet,npts,dim,mode1);
        
        
        if(abs(Vo3(1)-Vo3(2))<10)
            pos1 = min(Io3(1),Io3(2));
            pos2 = max(Io3(1),Io3(2));
            posfrontal2=round((pos1+pos2)/2);
            imwrite(imread(strcat(s1,names{1,1}{posfrontal2,1})),strcat(localresults,'cfrontal1_sim.png'));
            imwrite(imread(strcat(s1,names{1,2}{posfrontal2,1})),strcat(localresults,'dfrontal1_sim.png'));
            posF2=posfrontal2;
            if(code==3)
                a=1
                imwrite(imread(strcat(s1,names{1,1}{pos1,1})),strcat(localresults,'cright1_sim.png'));
                imwrite(imread(strcat(s1,names{1,2}{pos1,1})),strcat(localresults,'dright1_sim.png'));
                imwrite(imread(strcat(s1,names{1,1}{pos2,1})),strcat(localresults,'cleft1_sim.png'));
                imwrite(imread(strcat(s1,names{1,2}{pos2,1})),strcat(localresults,'dleft1_sim.png'));   
                posR2=pos1;
                posL2=pos2;
            else
                a=2
                imwrite(imread(strcat(s1,names{1,1}{pos2,1})),strcat(localresults,'cright1_sim.png'));
                imwrite(imread(strcat(s1,names{1,2}{pos2,1})),strcat(localresults,'dright1_sim.png'));
                imwrite(imread(strcat(s1,names{1,1}{pos1,1})),strcat(localresults,'cleft1_sim.png'));
                imwrite(imread(strcat(s1,names{1,2}{pos1,1})),strcat(localresults,'dleft1_sim.png'));     
                posL2=pos1;
                posR2=pos2;
            end
        else
            [ca, idx] = min(abs(measurements(posfrontal2:tamanho,2)-valormedio));
            pos1 =posfrontal2+idx;
            [ca, idx] = min(abs(measurements(1:posfrontal2,2)-valormedio));
            pos2 = idx;
            if(code==3)
                a=3
                imwrite(imread(strcat(s1,names{1,1}{pos2,1})),strcat(localresults,'cright1_sim.png'));
                imwrite(imread(strcat(s1,names{1,2}{pos2,1})),strcat(localresults,'dright1_sim.png'));
                imwrite(imread(strcat(s1,names{1,1}{pos1,1})),strcat(localresults,'cleft1_sim.png'));
                imwrite(imread(strcat(s1,names{1,2}{pos1,1})),strcat(localresults,'dleft1_sim.png'));     
                posL2=pos1;
                posR2=pos2; 
            else
                a=4
                imwrite(imread(strcat(s1,names{1,1}{pos1,1})),strcat(localresults,'cright1_sim.png'));
                imwrite(imread(strcat(s1,names{1,2}{pos1,1})),strcat(localresults,'dright1_sim.png'));
                imwrite(imread(strcat(s1,names{1,1}{pos2,1})),strcat(localresults,'cleft1_sim.png'));
                imwrite(imread(strcat(s1,names{1,2}{pos2,1})),strcat(localresults,'dleft1_sim.png'));    
                posR2=pos1;
                posL2=pos2; 
            end
        end
    else
        a=5
        [ca, idx] = min(abs(measurements(posfrontal2:round(tamanho/2),2)-valormedio));
        pos1 =posfrontal2+idx;
        [ca, idx] = min(abs(measurements(1:posfrontal2,2)-valormedio));
        pos2 = idx;
        imwrite(imread(strcat(s1,names{1,1}{pos1,1})),strcat(localresults,'cright1_sim.png'));
        imwrite(imread(strcat(s1,names{1,2}{pos1,1})),strcat(localresults,'dright1_sim.png'));
        imwrite(imread(strcat(s1,names{1,1}{pos2,1})),strcat(localresults,'cleft1_sim.png'));
        imwrite(imread(strcat(s1,names{1,2}{pos2,1})),strcat(localresults,'dleft1_sim.png'));    
                posR2=pos1;
                posL2=pos2; 
    end
    %%
%1st method - 1st turn
poslatesq=1;
for i=1: tamanho
   if(measurements(i,2)>valormedio)
       poslatesq=i;
       break;
   end
end
if(code==3)
    imwrite(imread(strcat(s1,names{1,1}{poslatesq,1})),strcat(localresults,'cright1.png'));
    imwrite(imread(strcat(s1,names{1,2}{poslatesq,1})),strcat(localresults,'dright1.png'));  
        posR1=poslatesq;
else
    imwrite(imread(strcat(s1,names{1,1}{poslatesq,1})),strcat(localresults,'cleft1.png'));
    imwrite(imread(strcat(s1,names{1,2}{poslatesq,1})),strcat(localresults,'dleft1.png'));
        posL1=poslatesq;
end

if(code==1)
    a=round(tamanho/2);
else
    a=tamanho;
end;

if(code~=1)
    poslatdir=a;
    for i=a:-1:1
       if(measurements(i,2)>valormedio)
           poslatdir=i;
           break;
       end
    end
else
    poslatdir=1;
    for i=poslatesq: a
        flag1=((measurements(i+1,2)<valormedio));
        flag2=((measurements(i+2,2)<valormedio));
        flag3=((measurements(i+3,2)<valormedio));
        flag4=((measurements(i+4,2)<valormedio));
        flag5=((measurements(i+5,2)<valormedio));
        flagTotal=flag1+flag2+flag3+flag4+flag5;
       if((measurements(i-2,2)<valormedio) && flagTotal>4)
           poslatdir=i-3;
           break;
       end
    end
end
if(code==3)
    imwrite(imread(strcat(s1,names{1,1}{poslatdir,1})),strcat(localresults,'cleft1.png'));
    imwrite(imread(strcat(s1,names{1,2}{poslatdir,1})),strcat(localresults,'dleft1.png'));
        posL1=poslatdir;
else
    imwrite(imread(strcat(s1,names{1,1}{poslatdir,1})),strcat(localresults,'cright1.png'));
    imwrite(imread(strcat(s1,names{1,2}{poslatdir,1})),strcat(localresults,'dright1.png'));
        posR1=poslatdir;
end

posfrontal=floor(((poslatdir)+(poslatesq))/2);
imwrite(imread(strcat(s1,names{1,1}{posfrontal,1})),strcat(localresults,'cfrontal1.png'));
imwrite(imread(strcat(s1,names{1,2}{posfrontal,1})),strcat(localresults,'dfrontal1.png'));
posF1=posfrontal;
%         if(plotOption==1)
%                 figure(22);
%             imshow(letfResult);
%                 figure(24);
%             imshow(rightResult);
%                 figure(26);
%             imshow(frontalResult);
%         end;
if(code==1)
        posfrontal2=max(Io1(1),Io1(2));
        [ca, idx] = min(abs(measurements(posfrontal2:tamanho,2)-valormedio));
        pos3 = posfrontal2+idx;
        [ca, idx] = min(abs(measurements(round(tamanho/2):posfrontal2,2)-valormedio));
        pos4 = round(tamanho/2)+idx;
        imwrite(imread(strcat(s1,names{1,1}{posfrontal2,1})),strcat(localresults,'cfrontal2_sim.png'));
        imwrite(imread(strcat(s1,names{1,2}{posfrontal2,1})),strcat(localresults,'dfrontal2_sim.png'));
        imwrite(imread(strcat(s1,names{1,1}{pos4,1})),strcat(localresults,'cright2_sim.png'));
        imwrite(imread(strcat(s1,names{1,2}{pos4,1})),strcat(localresults,'dright2_sim.png'));
        imwrite(imread(strcat(s1,names{1,1}{pos3-2,1})),strcat(localresults,'cleft2_sim.png'));
        imwrite(imread(strcat(s1,names{1,2}{pos3-2,1})),strcat(localresults,'dleft2_sim.png'));
    %1st method - 2nd turn
    poslatesq=1;
    for i=tamanho:-1:1
       if(measurements(i,2)>valormedio)
           poslatesq=i;
           break;
       end
    end
    imwrite(imread(strcat(s1,names{1,1}{poslatesq,1})),strcat(localresults,'cleft2.png'));
    imwrite(imread(strcat(s1,names{1,2}{poslatesq,1})),strcat(localresults,'dleft2.png'));
    for i=poslatesq:-1:1
        flag1=((measurements(i-1,2)<valormedio));
        flag2=((measurements(i-2,2)<valormedio));
        flag3=((measurements(i-3,2)<valormedio));
        flag4=((measurements(i-4,2)<valormedio));
        flag5=((measurements(i-5,2)<valormedio));
        flagTotal=flag1+flag2+flag3+flag4+flag5;
       if((measurements(i+2,2)<valormedio) && flagTotal>4)
           poslatdir=i+3;
           break;
       end
    end
    imwrite(imread(strcat(s1,names{1,1}{poslatdir,1})),strcat(localresults,'cright2.png'));
    imwrite(imread(strcat(s1,names{1,2}{poslatdir,1})),strcat(localresults,'dright2.png'));
    posfrontal=floor(((poslatdir)+(poslatesq))/2);
    imwrite(imread(strcat(s1,names{1,1}{posfrontal,1})),strcat(localresults,'cfrontal2.png'));
    imwrite(imread(strcat(s1,names{1,2}{posfrontal,1})),strcat(localresults,'dfrontal2.png'));            
%             if(plotOption==1)
%                     figure(30);
%                 imshow(letfResult);
%                     figure(31);
%                 imshow(rightResult);
%                     figure(32);
%                 imshow(frontalResult);
%             end;
end;