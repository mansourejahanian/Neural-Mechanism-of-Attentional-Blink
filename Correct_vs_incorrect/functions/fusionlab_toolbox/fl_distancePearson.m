function dist = fl_distancePearson(data,condid,varargin)

%
%
% Author: Yalda Mohsenzadeh 


%% parse inputs

numpermutation  = fl_inputparser(varargin,'numpermutation',100, @(x) isscalar(x) && x>0 && x == round(x) );
kfold           = fl_inputparser(varargin,'kfold',5, @(x) isscalar(x) && x>=2 && x == round(x));
method          = fl_inputparser(varargin,'method','pairwise',{'pairwise','temporalgen'}); 
whiten          = fl_inputparser(varargin,'whiten',true);
verbose         = fl_inputparser(varargin,'verbose',false);


%% check inputs and convert string labels to numbers

[condlabel,condidval,conditiongen,data2,condlabel2,condidval2] = fl_checkdatacondid(data,condid,varargin{:});


%% initialize variables

numcond = length(condlabel); %number of conditions
rng('shuffle'); %seed the random number generator based on the current time
% d = 0; %store decoding results
d2 = 0; %store decoding results (if cross-condition generalized)


%% normalize: divide every variable at every time point by its s.d.

sd = std(data,[],3,'omitnan');
data = bsxfun(@rdivide,data,sd); %important step to equaly weight all variables
if conditiongen
    data2 = bsxfun(@rdivide,data2,sd); %important step to equally weight all variables
end


%% compute cross-validated Euclidean distance
for p = 1:numpermutation
    
    %% verbose permutation
    
    if verbose & ~rem(p,verbose)
        disp(['Permutation: ' num2str(p) ' out of ' num2str(numpermutation)]);
    end
    
    
    %% assign data to k folds
    
    foldid = fl_createfolds(condidval,kfold);
    for c = 1:numcond
        traindata{c} = mean(data(:,:,condidval==c & foldid<=kfold),3);
%         testdata{c} = mean(data(:,:,condidval==c & foldid==kfold),3);
%         if conditiongen
%             n = nnz(condidval==c & foldid==kfold); %we need that many elements from data2
%             cndx = find(condidval2==c); %available elements in condition c
%             testdata2{c} = mean(data2(:,:,cndx(randperm(length(cndx),n))),3);
%         end
    end
    
    
    %% multivariate noise normalization (whiten data)
    
    if whiten        
        %compute whitening matrix using only training data
        down = max(round(size(data,2)/100),1); %downsample the data to make computation fast
        W = fl_whitenmatrix(data(:,1:down:end,foldid<kfold),condidval(foldid<kfold));        
        %apply whitening matrix
        for c = 1:numcond
            traindata{c} = W*traindata{c}; %multiply data with whitener 
%             testdata{c} = W*testdata{c}; %multiply data with whitener 
%             if conditiongen
%                 testdata2{c} = W*testdata2{c};
%             end
        end
    end
    

    %% Euclidean cross-validated distance
    
%     d = d + corr(traindata,'type', 'Pearson');
  
    for cond =1:length(traindata)
        tdata(cond, :, :) = traindata{cond};
    end
    
    parfor t =1:size(tdata,3)
        d(t,:) = squareform(1-corr(squeeze(tdata(:,:,t))'));
    end
    
    
    
end


%% normalize output

d = d/numpermutation; %divide by number of permutations

% d2 = d2/numpermutation; %divide by number of permutations


%% parse output

dist.d                 = d;
dist.condlabel         = condlabel;
dist.numpermutation    = numpermutation;
dist.kfold             = kfold;
dist.whiten            = whiten;
dist.method            = method;
% if conditiongen
%     dist.d2            = d2;
%     dist.condlabel2    = condlabel2;
% end


%% local function; computes Pearson cross-validated distance
% function d = distancePearsoncv(traindata,testdata,method)  
% 
% %initial variables
% ncond = length(traindata);
% ntimes = size(traindata{1},2);
% [x,y] = find(tril(ones(ncond,ncond),-1)); %indices of lower triangle
% 
% switch method
%     
%     case 'pairwise'
%         
%         %pairwise Pearson cross-validated distance
%         d = zeros(ntimes,ncond*(ncond-1)/2,'single');
%         for i = 1:length(x)
%             %             d(:,i) = sum( (traindata{x(i)}-traindata{y(i)}).*(testdata{x(i)}-testdata{y(i)}))'; %cross-validated Euclidean distance
%             
%             parfor t =1:ntimes
%                 temp11 = traindata{x(i)};
%                 temp12 = traindata{y(i)};
%                 temp22 =   testdata{y(i)};
%                 temp21 =   testdata{x(i)};
%                 temp_cov1 = (cov(temp11(:,t),temp22(:,t)) + cov(temp12(:,t), temp21(:,t)));
%                 temp_cov2 = cov(temp11(:,t), temp12(:,t));
%                 temp_cov3 = cov(temp21(:,t), temp22(:,t));
%                 
%                 d(t,i) = 1-0.5* (temp_cov1(1,2))/ (temp_cov2(1,2)*temp_cov3(1,2)); %cross-validated Pearson distance
%             end
%             
%         end
%         
%     case 'temporalgen'
%         
%         %pairwise Pearson cross-valideated with temporal generalization
%         d = zeros(ntimes,ntimes,ncond*(ncond-1)/2,'single');
%         for i = 1:length(x)
%             d(:,:,i) = (traindata{x(i)}-traindata{y(i)})' * (testdata{x(i)}-testdata{y(i)}); %cross-validated Euclidean distance
%         end
%         
% end
% 
% 


