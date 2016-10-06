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
K = 5;
k = 4;
n = 4;
num = length(images);
knn = cell(1,num);
for i = 1:num
    if mod(i,1000) == 0
        fprintf('Compute distance: %d/%d\n',i,num);
    end
    dist = sum((f_pca - repmat(f_pca(i,:),[num,1])).^2,2);
    [dist_sorted, ind] = sort(dist,'ascend');
    knn{i} = ind(2:K+1)';
end
knn = cat(1,knn{:});

c = [];
for i = 1:num
    if mod(i,1000) == 0
        fprintf('Extract circles: %d/%d\n',i,num);
    end
    a{1} = i;
    for j = 2:n+1
        a{j} = [];
        for t = 1:length(a{j-1})
            a{j} = [a{j},knn(a{j-1}(t),1:k)];
        end
    end
    mid = find(a{n+1}==i);
    if isempty(mid)
        continue;
    end
    for m = 1:length(mid)
        bid(n+1) = mid(m);
        b(n+1) = a{n+1}(bid(n+1));
        for j = n:-1:1
            bid(j) = ceil(bid(j+1)/k);
            b(j) = a{j}(bid(j));
        end
        if length(unique(b)) < n
            continue;
        end
        c = [c;b];
    end
end

fprintf('Extract positive pairs...\n');
p = cell(1,size(c,1));
for i = 1:size(c,1)
    p{i} = nchoosek(c(i,1:end-1),2);
end
p = cat(1,p{:});
ind = find(p(:,2)<p(:,1));
p(ind,:) = p(ind,[2 1]);
pos = unique(p,'rows');

save('pairs_pos.mat','pos');

