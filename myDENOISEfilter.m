function [result] = myDENOISEfilter(pathname, filename, finalname)
%% [ptCloudOut,inlierIndices,outlierIndices] = MYPCDENOISE(xyz, nNeigh, Thresh)
%
%   INPUTS:
%   pathname 	-   Path of the input and output files.
%   filename  -   Name of the input point cloud.
%   finalname  -   Final name of the point cloud to ouput.
%
%   OUTPUTS:
%   result   -   result if success or not.
%
% by António Pintor (abpintor@hotmail.com) 
% May 2016
    %% Get point cloud
%     tic
    pcF=plyToMatSO(pathname,filename);
%     toc
%     tic
    %% set parameters
    stdev = std(pcF(:,1:3), 1, 1);
    stdD = sqrt(sum(stdev.^2));
    qua1=pcF(pcF(:,1)>0 & pcF(:,2)>=0,:);
    qua2=pcF(pcF(:,1)<=0 & pcF(:,2)>0,:);
    qua3=pcF(pcF(:,1)<0 & pcF(:,2)<=0,:);
    qua4=pcF(pcF(:,1)>=0 & pcF(:,2)<0,:);
    qua={qua1,qua2,qua3,qua4};
    %% start filtering
    outs= cell(4);
    parfor i= 1:4
        [~,idx]=mypcdenoise3(qua{i}(:,1:3),100,0.05,stdD);
%         fprintf(2,'Finished worker %d',i);
        outs{i}=qua{i}(idx,:);
    end
    outi=[outs{1,1};outs{2,1};outs{3,1};outs{4,1}];
    %% get output
%     toc
%     tic
    pcOut=outi;
    tamanho=size(pcOut,1);
    %% write to new file
    writePly(pathname,finalname,pcOut,tamanho);
%     toc
%     fprintf(2,'Finished\n');
    result=1;
end