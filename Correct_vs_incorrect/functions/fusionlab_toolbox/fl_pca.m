function [data_pca,k,explained] = fl_pca(data,explainedvar)

%preliminary code, undocumented; please do not distribute
%data is 3D (variables, timepoints,observations)
%
%




%initialize
if ~exist('explainedvar')
    explainedvar = 99.99; %default, explain 99.99% of variance
end
[nvar,ntimes,ntrials] = size(data);

%reshape data to 2D
data = reshape(data,nvar,[]);

%perform pca
[coeff,data_pca,latent,tsquared,explained,mu] = pca(data'); %second dimension is variables (i.e. 306 channels)
clear data
% to check compression, compute:
% dat_reconstructed = coeff*score' + repmat(mu,size(score,1),1)';

%keep first k components
k = min(find(cumsum(explained)>=explainedvar)); 
%k = max(k,ceil(nvar/3));
explained = sum(explained(1:k)); %variance explained

%output data
data_pca = data_pca(:,1:k)';
data_pca = reshape(data_pca,k,ntimes,ntrials);