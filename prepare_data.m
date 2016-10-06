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
f = fopen('cifar_train.txt','w');
if ~exist(['./datasets/CIFAR10/train'],'file')
    mkdir(['./datasets/CIFAR10/train']);
end
images = {};
for i = 1:5
    load(['./datasets/CIFAR10/data_batch_' num2str(i) '.mat']);
    for j = 1:length(labels)
        im = reshape(data(j,:),[32,32,3]);
        im(:,:,1) = im(:,:,1)';
        im(:,:,2) = im(:,:,2)';
        im(:,:,3) = im(:,:,3)';
        imwrite(im,[pwd '/datasets/CIFAR10/train/' num2str(i) '_' num2str(j) '.jpg']);
        fprintf(f,'%s %d\n',[pwd '/datasets/CIFAR10/train/' num2str(i) '_' num2str(j) '.jpg'],labels(j));
        images{(i-1)*1e4+j} = [num2str(i) '_' num2str(j) '.jpg'];
    end
end
fclose(f);
if ~exist(['./data/CIFAR10'],'file')
    mkdir(['./data/CIFAR10']);
end
save('./data/CIFAR10/images.mat','images');

f = fopen('cifar_test.txt','w');
load(['./datasets/CIFAR10/test_batch.mat']);
if ~exist(['./datasets/CIFAR10/test'],'file')
    mkdir(['./datasets/CIFAR10/test']);
end
for j = 1:length(labels)
    im = reshape(data(j,:),[32,32,3]);
    im(:,:,1) = im(:,:,1)';
    im(:,:,2) = im(:,:,2)';
    im(:,:,3) = im(:,:,3)';
    imwrite(im,[pwd '/datasets/CIFAR10/test/' num2str(j) '.jpg']);
    fprintf(f,'%s %d\n',[pwd '/datasets/CIFAR10/test/' num2str(j) '.jpg'],labels(j));
end
fclose(f);
