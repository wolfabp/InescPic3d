% img=imread('');
% figure(1);
% imshow(img);

clc;
clear;
% MyDirInfo = dir('D:\INESC\DadosTese\PX_044_001_U\Kinect1');
MyDirInfo = dir('D:\INESC\DadosTese\PX_044_002_Z\Kinect1');
% MyDirInfo = dir('D:\INESC\DadosTese\PX_044_003_E\Kinect1');
% MyDirInfo = dir('D:\INESC\DadosTese\PX_044_004_K\Kinect1');

%% Get Files names
fieldname='name';
pos=3;
filenames= cell(max(size(MyDirInfo))-2,1);
while(1)
    if(pos>max(size(MyDirInfo)))
        break;
    end;
    filenames{pos-2}=[MyDirInfo(pos).(fieldname)];
    pos=pos+1;
end;

%% Separate Color and Depth files names
pos=1;
ColorFilesNames= cell(max(size(filenames)),1);
DepthFilesNames= cell(max(size(filenames)),1);
posColor=1;
posDepth=1;
while(1)
    if(pos>max(size(filenames)))
        break;
    end;
    k = strfind(filenames{pos}, 'Color');
    if(size(k)>0)
        ColorFilesNames{posColor}=filenames{pos};
        posColor=posColor+1;
    end;
    k = strfind(filenames{pos}, 'Depth');
    if(size(k)>0)
        DepthFilesNames{posDepth}=filenames{pos};
        posDepth=posDepth+1;
    end;
    pos=pos+1;
end;

%% Match Color and Depth files names

pos=1;
finalFilesNames= cell(max(size(filenames)),2);
tamanho=min(posDepth-1,posColor-1);
Tdepthold=1000;

depthTimes=zeros(max(size(DepthFilesNames)));
ColorTimes=zeros(max(size(ColorFilesNames)));

for posColor=1 : max(size(ColorFilesNames))
    ColorTimes(posColor)=getTime(ColorFilesNames{posColor});
end;

for posDepth=1 : max(size(DepthFilesNames))
    depthTimes(posDepth)=getTime(DepthFilesNames{posDepth});
end;

totalTimes=abs(ColorTimes-depthTimes);
totalTimes=totalTimes(1:tamanho)';

%% Write to file
fileID = fopen('DataMatchNames2.txt','w');
for i =1 : tamanho
    if(totalTimes(i)<60)
        fprintf(fileID,'%s,%s;\n\r',ColorFilesNames{i},DepthFilesNames{i});
    end
end
fclose(fileID);
