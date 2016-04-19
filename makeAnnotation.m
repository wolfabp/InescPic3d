% Annotations Maker
clc;
clear;
close all;
%% Select Patient folder
s1 = strcat(uigetdir('D:\INESC\DadosTese\','Select Patient'),'\Kinect1\');
getPairs(s1);
fileID = fopen(strcat(s1,'DataMatchNames.txt'));
names =textscan(fileID,'%s %s');
tamanho=max(size(names{1,1}));
%% Get info Calib
k = strfind(s1,'\DadosTese\');
tam=size('\DadosTese\',2);
subs1=s1((tam+k):size(s1,2));
k1 = strfind(subs1,'\');
MyDirInfo = dir(strcat(s1(1:tam+k+size(subs1(1:k1(1)),2)-1),'calib\'));
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
num=6;
temposIdeais=zeros(num,1);
%% Select Ideal Poses
% figure(1);
% imshow(imread('pose_F.png','png'));
[limitF1min, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
            '*.*','All Files (*.*)'}, 'Select Patient Frontal minimal',s1,'MultiSelect', 'on');
temposIdeais(1)=getTime(limitF1min{1});
temposIdeais(2)=getTime(limitF1min{2});

% imshow(imread('pose_R.png','png'));
[limitR1min, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
            '*.*','All Files (*.*)'}, 'Select Patient Right minimal',s1,'MultiSelect', 'on');
temposIdeais(3)=getTime(limitR1min{1});
temposIdeais(4)=getTime(limitR1min{2});

% imshow(imread('pose_L.png','png'));
[limitL1min, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
            '*.*','All Files (*.*)'}, 'Select Patient Left minimal',s1,'MultiSelect', 'on');
temposIdeais(5)=getTime(limitL1min{1});
temposIdeais(6)=getTime(limitL1min{2});

%% Find Closest TimeStamp
temposmin=zeros(num,2);
temposmin(:,1)=10000000;

for i=1: tamanho
    str=names{1,1}{i,1};
    tempo1=getTime(strcat(s1,str));
    for j=1:num
        difff=abs(tempo1-temposIdeais(j));
        if(temposmin(j,1)>difff)
            temposmin(j,1)=difff;
            temposmin(j,2)=i;
        end
    end
end

%% Write to XML File
%
limitF1min=temposmin(1,2);
limitF1max=temposmin(2,2);
limitR1min=temposmin(3,2);
limitR1max=temposmin(4,2);
limitL1min=temposmin(5,2);
limitL1max=temposmin(6,2);

docNode = com.mathworks.xml.XMLUtils.createDocument('Pose');
docRootNode = docNode.getDocumentElement;

docRootNode1 = docRootNode.appendChild(docNode.createElement('Frontal'));  
thisElement = docNode.createElement('min');
thisElement.appendChild(docNode.createTextNode(num2str(limitF1min)));
docRootNode1.appendChild(thisElement);
thisElement = docNode.createElement('max');
thisElement.appendChild(docNode.createTextNode(num2str(limitF1max)));
docRootNode1.appendChild(thisElement);

docRootNode2 = docRootNode.appendChild(docNode.createElement('Right'));  
thisElement = docNode.createElement('min');
thisElement.appendChild(docNode.createTextNode(num2str(limitR1min)));
docRootNode2.appendChild(thisElement);
thisElement = docNode.createElement('max');
thisElement.appendChild(docNode.createTextNode(num2str(limitR1max)));
docRootNode2.appendChild(thisElement);

docRootNode3 = docRootNode.appendChild(docNode.createElement('Left')); 
thisElement = docNode.createElement('min');
thisElement.appendChild(docNode.createTextNode(num2str(limitL1min)));
docRootNode3.appendChild(thisElement);
thisElement = docNode.createElement('max');
thisElement.appendChild(docNode.createTextNode(num2str(limitL1max)));
docRootNode3.appendChild(thisElement);

xmlFileName = [s1,'idealPosesLimits','.xml'];
xmlwrite(xmlFileName,docNode);
% edit(xmlFileName);