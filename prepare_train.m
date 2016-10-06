% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2016, Dong Li
% 
% This file is part of the FeatureLearning code and is available 
% under the terms of the MIT License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

clear; clc; close all;
[ims,label] = textread('cifar_train.txt','%s %d');
load('pairs_pos.mat');
load('pairs_neg.mat');
num = size(pos,1);
rid = randperm(size(neg,1));
fid1 = fopen('cifar_train_a.txt','w');
fid2 = fopen('cifar_train_b.txt','w');
for i = 1:num
    im1 = ims{pos(i,1)};
    im2 = ims{pos(i,2)};
    fprintf(fid1,'%s %d\n',im1,1);
    fprintf(fid2,'%s %d\n',im2,1);
    im1 = ims{neg(rid(i),1)};
    im2 = ims{neg(rid(i),2)};
    fprintf(fid1,'%s %d\n',im1,0);
    fprintf(fid2,'%s %d\n',im2,0); 
end
fclose(fid1);
fclose(fid2);