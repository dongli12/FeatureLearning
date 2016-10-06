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
system(['ln -s ' pwd '/datasets/CIFAR10/train ' pwd '/data/CIFAR10/images']);
cd features;
launch_fv_comp;
cd ..;
load('./data/CIFAR10/images.mat');
num = length(images);
f = {};
for i = 1:num
    load(['./feat/CIFAR10/' images{i} '.mat']);
    f{i} = single(fv_raw');
end
f_all = cat(1,f{:});
A = pca(f_all);
M = 512;
f_pca = f_all*A(:,1:M);
save('-v7.3','f_pca_512.mat','f_pca');