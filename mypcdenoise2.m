function [ptCloudOut,inlierIndices,outlierIndices] = mypcdenoise2(xyz, nNeigh, Thresh)
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
% updated by António Pintor (abpintor@hotmail.com)
% May 2016

if isempty(nNeigh)
    nNeigh = 4;
end
if isempty(Thresh)
    Thresh = 1.0;
end

stdev = std(xyz, 1, 1);
stdD = sqrt(sum(stdev.^2));

%try to (better) preallocate outputs and then reduce
ptCloudOut = zeros(size(xyz,1), size(xyz,2));
inlierIndicesI = zeros(size(xyz,1),1);
ini=1;
outlierIndicesI = zeros(size(xyz,1),1);
outi=1;


for ii = 1 : size(xyz,1)
    vv = xyz(ii,:);
    err = repmat(vv,length(xyz),1) - xyz;
    err = err.^2;
    err = sum(err,2);
    err = sqrt(err);
    err = sort(err, 'ascend');
    meD = mean(err(2:(nNeigh+1) ,:), 1);  %remove itself first (distance of zeros)
    if( meD/stdD < Thresh )
        inlierIndicesI(ini) = ii;
        ptCloudOut(ini,:) = vv;
        ini=ini+1;
    else
        outlierIndicesI(outi) = ii;
        outi=outi+1;
    end
end

ptCloudOut(ini:end,:) = [];
inlierIndices = inlierIndicesI(1:ini);
outlierIndices = outlierIndicesI(1:outi);

end