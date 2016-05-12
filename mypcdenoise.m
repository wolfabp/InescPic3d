function [ptCloudOut,inlierIndices,outlierIndices] = mypcdenoise(xyz, nNeigh, Thresh,stdD)
%% [ptCloudOut,inlierIndices,outlierIndices] = MYPCDENOISE(xyz, nNeigh, Thresh)
%
%   INPUTS:
%   xyz 	-   Nxm  matrix of point coordinates (m usually is 3, XYZ).
%   nNeigh  -   Scalar, number of nearest neighbours to compare distances
%       to. Default is 4.
%   Thresh  -   Scalar, normalized distance (based on standard deviation
%       between points ). Default is 1.0 .
%
%   OUTPUTS:
%   ptCloudOut      -   Nxm  matrix of point coordinates with inlier points. 
%   inlierIndices   -   Kx1, Inlier point indices.
%   outlierIndices  -   Lx1, Outlier point indices
%
% by João Teixeira (jpfteixeira.eng@gmail.com) 
% May 2016

%V2 - with memory pre-allocation
xyz=gpuArray(xyz);
if isempty(nNeigh)
    nNeigh = 4;
end
if isempty(Thresh)
    Thresh = 1.0;
end
 
% stdev = std(xyz, 1, 1);
% stdD = sqrt(sum(stdev.^2));

ab=length(xyz);
ptCloudOut = gpuArray(zeros(size(xyz)));
inlierIndices = gpuArray(zeros(ab,1));
outlierIndices = gpuArray(zeros(ab,1));

in = 1;
out = 1;
for ii = 1 : ab
    vv = xyz(ii,:);
%     err = repmat(vv,cb,1) - xyz;
    err = sqrt(sum((repmat(vv,ab,1) - xyz).^2,2));
%     err = sort(err, 'ascend');
%     meD = mean(err(2:(nNeigh+1) ,:), 1);  %remove itself first (distance of zeros)
    maxErr=max(err);
    err(ii)=maxErr*2;
    nNV=gpuArray(zeros(nNeigh,1));
    for j=1:nNeigh
        [minimo,idx]= min(err);
        err(idx)=maxErr*2;
        nNV(j)=minimo;        
    end
    meD=mean(nNV);
    if( meD/stdD < Thresh )
        inlierIndices(in) = ii;
        ptCloudOut(in,:) = vv;
        in = in+1;
    else
        outlierIndices(out) = ii;
        out = out+1;
    end
end
ptCloudOut(in:end,:) = [];
inlierIndices(in:end) = [];
outlierIndices(out:end) = [];

ptCloudOut= gather(ptCloudOut);
inlierIndices= gather(inlierIndices);
outlierIndices= gather(outlierIndices);
% xyz= gather(xyz);
% wait(gpuDevice);
end