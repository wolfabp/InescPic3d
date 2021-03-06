clc;
clear;
close all;
%% Select folder and pair images with depth
s1 = uigetdir('D:\INESC\DadosTese\','Select Patients location');
MyDirInfo = dir(s1);
fieldname='name';
filenames= cell(size(MyDirInfo,1),1);
tamanho=size(filenames,1);
R_sim_sucesso=0;
L_sim_sucesso=0;
F_sim_sucesso=0;
R_sucesso=0;
L_sucesso=0;
F_sucesso=0;

%% Scan All Patients
for i=3:tamanho
    %% Get patient and clean old results
    if(strcmp(MyDirInfo(i).('name'),'calib'))
        continue
    end
    disp(MyDirInfo(i).('name'));
    s2=[s1,'\',MyDirInfo(i).('name'),'\Kinect1\'];
    localresults=[s2,'Results\'];
    mkdir(localresults);
    pause(0.2);
    rmdir(localresults,'s') 
    pause(0.1);
    mkdir(localresults);
    %% Find poses
    [posL1,posF1,posR1,posL2,posF2,posR2]= SelectViews(s2,1);

    %% Read XML file for ideal Positions
    xDoc = xmlread(strcat(s2,'\idealPosesLimits.xml'));
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
        F_sucesso=F_sucesso+1;
    else
        disp('Out by: ');
        if(posF1<FLimitmin)
            disp((posF1-FLimitmin));
        else
            disp((posF1-FLimitmax));
        end
    end
    disp('Position of selected right area: ');
    if(posR1>=RLimitmin && posR1<=RLimitmax)
        disp('In');
        R_sucesso=R_sucesso+1;
    else
        disp('Out by: ');
        if(posR1<RLimitmin)
            disp((posR1-RLimitmin));
        else
            disp((posR1-RLimitmax));
        end
    end
    disp('Position of selected left area: ');
    if(posL1>=LLimitmin && posL1<=LLimitmax)
        disp('In');
        L_sucesso=L_sucesso+1;
    else
        disp('Out by: ');
        if(posL1<LLimitmin)
            disp((posL1-LLimitmin));
        else
            disp((posL1-LLimitmax));
        end
    end
    %Method 2 Simetry
    disp('Position of selected Frontal simetry: ');
    if(posF2>=FLimitmin && posF2<=FLimitmax)
        disp('In');
        F_sim_sucesso=F_sim_sucesso+1;
    else
        disp('Out by: ');
        if(posF2<FLimitmin)
            disp((posF2-FLimitmin));
        else
            disp((posF2-FLimitmax));
        end
    end
    disp('Position of selected right simetry: ');
    if(posR2>=RLimitmin && posR2<=RLimitmax)
        disp('In');
        R_sim_sucesso=R_sim_sucesso+1;
    else
        disp('Out by: ');
        if(posR2<RLimitmin)
            disp((posR2-RLimitmin));
        else
            disp((posR2-RLimitmax));
        end
    end
    disp('Position of selected left simetry: ');
    if(posL2>=LLimitmin && posL2<=LLimitmax)
        disp('In');
        L_sim_sucesso=L_sim_sucesso+1;
    else
        disp('Out by: ');
        if(posL2<LLimitmin)
            disp((posL2-LLimitmin));
        else
            disp((posL2-LLimitmax));
        end
    end
end

%% Estimation Success Rates
tamanho=tamanho-3;

R_sim=100*(R_sim_sucesso/tamanho);
F_sim=100*(F_sim_sucesso/tamanho);
L_sim=100*(L_sim_sucesso/tamanho);
R=100*(R_sucesso/tamanho);
F=100*(F_sucesso/tamanho);
L=100*(L_sucesso/tamanho);
