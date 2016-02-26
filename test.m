clc;
clear;
close all;
tic
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
flagFound=0;
maximaDiff=0;
fileID = fopen('DataMatchNames.txt','w');
Tdepthold=1000;
oldposdeth=3000;
for posColor=1 : max(size(ColorFilesNames))
    tempoColor=getTime(ColorFilesNames{posColor});
    if(tempoColor==-1)
        break;
    end;
    
    minimoDiff=100000;
    minpos=1;
    for posDepth=1 : max(size(DepthFilesNames))
        
        tempoDepth=getTime(DepthFilesNames{posDepth});
        if(tempoDepth==-1)
            break;
        end;
        diff=abs(tempoColor-tempoDepth);
        if(diff>70 && tempoColor<tempoDepth)
            break;
        end;
        if(minimoDiff>abs(diff))
            minimoDiff=abs(diff);
            minpos=posDepth;
        end
    end
        
    if(minimoDiff<=60 && oldposdeth~=minpos)
        flagFound=1;
        Tdepthold=tempoDepth;
    end
    oldposdeth=minpos;
    posDepth=minpos;
    
    if(flagFound==1)
        fprintf(fileID,'%s %s\r\n',ColorFilesNames{posColor},DepthFilesNames{posDepth});
%         finalFilesNames{pos,1}=ColorFilesNames{posColor};
%         finalFilesNames{pos,2}=DepthFilesNames{posDepth};
%         pos=pos+1;
        flagFound=0;
    end
    
end;

fclose(fileID);
toc