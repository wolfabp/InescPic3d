function [ptCloudOut,inlierIndices,outlierIndices] = mypcdenoise3(xyz, nNeigh, Thresh,stdD)
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

if isempty(nNeigh)
    nNeigh = 4;
end
if isempty(Thresh)
    Thresh = 1.0;
end

ptCloudOut = zeros(size(xyz));
inlierIndices = zeros(size(xyz,1),1);
outlierIndices = zeros(size(xyz,1),1);

in = 1;
out = 1;
for ii = 1 : size(xyz,1)
    vv = xyz(ii,:);
    err = repmat(vv,length(xyz),1) - xyz;
    err = sqrt(sum(err.^2,2));
    err = sort(err, 'ascend');
    meD = mean(err(2:(nNeigh+1) ,:), 1);  %remove itself first (distance of zeros)
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

end