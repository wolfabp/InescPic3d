clc;
clear;
close all;
%% Select folder and pair images with depth
s1 = strcat(uigetdir('D:\INESC\DadosTese\','Select Patient'),'\Kinect1\');
localresults=strcat(s1,'Results\');
mkdir(localresults);
pause(0.2);
rmdir(localresults,'s') 
pause(0.1);
mkdir(localresults);

%% Find poses
[posL1,posF1,posR1,posL2,posF2,posR2]= SelectViews(s1);

%% Read XML file for ideal Positions

xDoc = xmlread(strcat(s1,'idealPosesLimits.xml'));
           
allListitems = xDoc.getElementsByTagName('Pose');
thisListitem = allListitems.item(0);
Frontal = thisListitem.getElementsByTagName('Frontal');
thisElement = Frontal.item(0);
a=thisElement.getElementsByTagName('max');
b=a.item(0);
FLimitmax=str2double(b.getFirstChild.getData);
a=thisElement.getElementsByTagName('min');
b=a.item(0);
FLimitmin=str2double(b.getFirstChild.getData);

Right = thisListitem.getElementsByTagName('Right');
thisElement = Right.item(0);
a=thisElement.getElementsByTagName('max');
b=a.item(0);
RLimitmax=str2double(b.getFirstChild.getData);
a=thisElement.getElementsByTagName('min');
b=a.item(0);
RLimitmin=str2double(b.getFirstChild.getData);

Left = thisListitem.getElementsByTagName('Left');
thisElement = Left.item(0);
a=thisElement.getElementsByTagName('max');
b=a.item(0);
LLimitmax=str2double(b.getFirstChild.getData);
a=thisElement.getElementsByTagName('min');
b=a.item(0);
LLimitmin=str2double(b.getFirstChild.getData);


%% Calculate if esmitated pos are within the limits
%Method 1
disp('Position of selected Frontal area: ');
if(posF1>=FLimitmin && posF1<=FLimitmax)
    disp('In');
else
    disp('Out by: ');
    if(posF2<FLimitmin)
        disp(abs(FLimitmin-posF1));
    else
        disp(abs(FLimitmax-posF1));
    end
end
disp('Position of selected right area: ');
if(posR1>=RLimitmin && posR1<=RLimitmax)
    disp('In');
else
    disp('Out by: ');
    if(posF2<RLimitmin)
        disp(abs(RLimitmin-posR1));
    else
        disp(abs(RLimitmax-posR1));
    end
end
disp('Position of selected left area: ');
if(posL1>=LLimitmin && posL1<=LLimitmax)
    disp('In');
else
    disp('Out by: ');
    if(posL1<LLimitmin)
        disp(abs(LLimitmin-posL1));
    else
        disp(abs(LLimitmax-posL1));
    end
end


%Method 2 Simetry
disp('Position of selected Frontal simetry: ');
if(posF2>=FLimitmin && posF2<=FLimitmax)
    disp('In');
else
    disp('Out by: ');
    if(posF2<FLimitmin)
        disp(abs(FLimitmin-posF2));
    else
        disp(abs(FLimitmax-posF2));
    end
end
disp('Position of selected right simetry: ');
if(posR2>=RLimitmin && posR2<=RLimitmax)
    disp('In');
else
    disp('Out by: ');
    if(posF2<RLimitmin)
        disp(abs(RLimitmin-posR2));
    else
        disp(abs(RLimitmax-posR2));
    end
end
disp('Position of selected left simetry: ');
if(posL2>=LLimitmin && posL2<=LLimitmax)
    disp('In');
else
    disp('Out by: ');
    if(posL2<LLimitmin)
        disp(abs(LLimitmin-posL2));
    else
        disp(abs(LLimitmax-posL2));
    end
end