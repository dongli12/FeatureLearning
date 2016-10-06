% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2016, Dong Li
% 
% This file is part of the FeatureLearning code and is available 
% under the terms of the MIT License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

clear; close all; clc;
load('./data/CIFAR10/images.mat');
load('f_pca_512.mat');
num = 1e4;
K = 1000;
thr = 1.0;
pairs_neg = {};
for batch = 1:5
    fprintf('Batch: %d/%d\n',batch,5);
    sample = (batch-1)*num+1:batch*num;
    feat = f_pca(sample,:);
    knn_dist = zeros(num,num);
    for i = 1:num
        if mod(i,1000) == 0
            fprintf('Compute knn graph: %d/%d\n',i,num);
        end
        dist = sum((feat - repmat(feat(i,:),[num,1])).^2,2);
        [dist_sorted, ind] = sort(dist,'ascend');
        knn_dist(i,:) = dist;
        knn_dist(i,ind(K+1:end)) = inf;
    end
    fprintf('Extract negative pairs...\n');
    D = FastFloyd(knn_dist);
    ind = find(D>thr & D~=inf);
    if ~isempty(ind)
        len = length(ind);
        r = randperm(len);
        [ind1,ind2] = ind2sub([num,num],ind(r(1:min(1e5,len))));
        p = [ind1(:),ind2(:)];
        pairs_neg{batch} = sample(p);
    end
end
neg = cat(1,pairs_neg{:});
save('pairs_neg.mat','neg');
