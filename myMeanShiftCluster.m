function [clustCent,data2cluster,cluster2dataCell] = myMeanShiftCluster(dataPts,bandWidth, plotFlag, weights, initSeeds);
%perform MeanShift Clustering of data using a flat kernel
%
% ---INPUT---
% dataPts           - input data, (numDim x numPts)
% bandWidth         - is bandwidth parameter (scalar)
% plotFlag          - display output if 2 or 3 D    (logical)
% weights           - MODIFICATION, empty or numDim x 1 matrix with input
%                       weights
% initSeeds         - MODIFICATION, empty or numPts x 1 matrix with initial
%                       solution
% ---OUTPUT---
% clustCent         - is locations of cluster centers (numDim x numClust)
% data2cluster      - for every data point which cluster it belongs to (numPts)
% cluster2dataCell  - for every cluster which points are in it (numClust)
% 
% Modified: João Teixeira 04/02/2015
% Bryan Feldman 02/24/06
% MeanShift first appears in
% K. Funkunaga and L.D. Hosteler, "The Estimation of the Gradient of a
% Density Function, with Applications in Pattern Recognition"


%*** Check input ****
if nargin < 2
    error('no bandwidth specified')
end

if nargin < 3
    plotFlag = true;
%     plotFlag = false;
end

%**** Initialize stuff ***
[numDim,numPts] = size(dataPts);
numClust        = 0;
bandSq          = bandWidth^2;
initPtInds      = 1:numPts;
if(~isempty(weights))   %Unnecessary modifications
    dataPts         = dataPts.*repmat(weights', 1,size(dataPts, 2));
end
maxPos          = max(dataPts,[],2);                          %biggest size in each dimension
minPos          = min(dataPts,[],2);                          %smallest size in each dimension
boundBox        = maxPos-minPos;                        %bounding box size
sizeSpace       = norm(boundBox);                       %indicator of size of data space
stopThresh      = 1e-3*bandWidth;                       %when mean has converged
clustCent       = [];                                   %center of clust
beenVisitedFlag = zeros(1,numPts,'uint8');              %track if a points been seen already
beenVisitedFlag(isnan(dataPts(3,:))) = 1;               %ignore NaN points
numInitPts      = numPts;                               %number of points to possibly use as initilization points
numInitPts      = numPts-sum(beenVisitedFlag);    %number of points to possibly use as initilization points (except NaNs)
clusterVotes    = zeros(1,numPts,'uint16');             %used to resolve conflicts on cluster membership

% lperc = 0;
% nSeeds = numel(initSeeds);

while numInitPts
    
    if(~isempty(initSeeds))
       while 1
           if(numel(initSeeds))
               tempInd      = ceil( (numel(initSeeds)-1e-6)*rand);     %pick random centroid/seed point
               stInd        = initSeeds(tempInd);                      %use random seed as start of mean
               initSeeds = [initSeeds(1:tempInd-1); initSeeds(tempInd+1:end)]; %remove centroid from further inspection
               if(beenVisitedFlag(stInd))                              %use only if not visited already
                   continue;
               end
               break;
           else %occurs exactly once
               tempInd      = ceil( (numInitPts-1e-6)*rand);        %pick a random seed point
               stInd           = initPtInds(tempInd);                  %use this point as start of mean
               break;
           end
       end
       
    else
       tempInd      = ceil( (numInitPts-1e-6)*rand);        %pick a random seed point
       stInd           = initPtInds(tempInd);                  %use this point as start of mean
    end
    myMean          = dataPts(:,stInd);                           % intilize mean to this points location
    myMembers       = [];                                   % points that will get added to this cluster                          
    thisClusterVotes    = zeros(1,numPts,'uint16');         %used to resolve conflicts on cluster membership

    while 1     %loop untill convergence
        
        sqDistToAll = sum((repmat(myMean,1,numPts) - dataPts).^2, 1);    %dist squared from mean to all points still active
        inInds      = find(sqDistToAll < bandSq);               %points within bandWidth
        thisClusterVotes(inInds) = thisClusterVotes(inInds)+1;  %add a vote for all the in points belonging to this cluster
        
        
        myOldMean   = myMean;                                   %save the old mean
        myMean      = mean(dataPts(:,inInds),2);                %compute the new mean
        myMembers   = [myMembers inInds];                       %add any point within bandWidth to the cluster
        beenVisitedFlag(myMembers) = 1;                         %mark that these points have been visited
        
        %*** plot stuff ****
        if plotFlag
            if numDim <= 3 %just show xy information
                figure(12345),clf,hold on
                plot(dataPts(1,:),dataPts(2,:),'.')
                plot(dataPts(1,myMembers),dataPts(2,myMembers),'ys')
                plot(myMean(1),myMean(2),'go')
                plot(myOldMean(1),myOldMean(2),'rd')
                pause(0.2);
            end
        end

        %**** if mean doesn't move much stop this cluster ***
        if norm(myMean-myOldMean) < stopThresh
            
            %check for merge possibilities
            mergeWith = 0;
            for cN = 1:numClust
                distToOther = norm(myMean-clustCent(:,cN));     %distance from possible new clust max to old clust max
                if distToOther < bandWidth/2                    %if its within bandwidth/2 merge new and old
                    mergeWith = cN;
                    break;
                end
            end
            
            
            if mergeWith > 0    % something to merge
                clustCent(:,mergeWith)       = 0.5*(myMean+clustCent(:,mergeWith));             %record the max as the mean of the two merged (I know biased towards new ones)
                %clustMembsCell{mergeWith}    = unique([clustMembsCell{mergeWith} myMembers]);   %record which points inside 
                clusterVotes(mergeWith,:)    = clusterVotes(mergeWith,:) + thisClusterVotes;    %add these votes to the merged cluster
            else    %its a new cluster
                numClust                    = numClust+1;                   %increment clusters
                clustCent(:,numClust)       = myMean;                       %record the mean  
                %clustMembsCell{numClust}    = myMembers;                    %store my members
                clusterVotes(numClust,:)    = thisClusterVotes;
            end

            break;
        end

    end
    
%Debug    
%             figure(2);subplot(211); imshow(double(reshape(clusterVotes(end,:),60, 454) )/max(double(clusterVotes(:)))); %605
%             subplot(212); imshow(double(reshape(beenVisitedFlag, 60, 454) ));
    initPtInds      = find(beenVisitedFlag == 0);           %we can initialize with any of the points not yet visited
    numInitPts      = length(initPtInds);                   %number of active points in set

%   Ignore (for huge data)    
%     if(numel(initSeeds))
%         if( ~mod(numel(initSeeds), floor(nSeeds/10000) ) )
%             perc2 = (nSeeds-sum(initSeeds))/nSeeds;
%             fprintf(1,'Seeds Visited: %.2f%% (total:%d)\n', perc2, nSeeds);
%         end
%     else
%         perc = sum(beenVisitedFlag)/numel(beenVisitedFlag);
%         if( floor(perc*1000)~= floor(lperc*1000) )
%             fprintf(1,'Visited: %.2f%% (total:%d)\n', sum(beenVisitedFlag)/numel(beenVisitedFlag), numel(beenVisitedFlag));
%             lperc = perc;
%         end        
%     end
    
end

[val,data2cluster] = max(clusterVotes,[],1);                %a point belongs to the cluster with the most votes

%*** Find the cluster2data cell
if nargout > 2
    cluster2dataCell = cell(numClust,1);
    for cN = 1:numClust
        myMembers = find(data2cluster == cN);
        cluster2dataCell{cN} = myMembers;
    end
end


