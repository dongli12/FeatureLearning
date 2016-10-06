% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2016, Dong Li
% 
% This file is part of the FeatureLearning code and is available 
% under the terms of the MIT License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

clear all; close all; clc;
net_file = 'model_cifar_alexnet_iter_50000.caffemodel';
net_def_file = 'alexnet_fc7.prototxt';
caffe.set_mode_gpu();
gpu_id = 0;
caffe.set_device(gpu_id);
net = caffe.Net(net_def_file, net_file, 'test');
crop_size = 227;
batch_size = 50;
[imdir,label] = textread('cifar_train.txt','%s %d');
num_im = length(imdir);

fprintf('preprocess ...\n');
num_batches = ceil(num_im / batch_size);
batch_padding = batch_size - mod(num_im, batch_size);
if batch_padding == batch_size
  batch_padding = 0;
end
batches = cell(num_batches, 1);
for batch = 1:num_batches
  batch_start = (batch-1)*batch_size+1;
  batch_end = min(num_im, batch_start+batch_size-1);
  ims = zeros(crop_size, crop_size, 3, batch_size, 'single');
  for j = batch_start:batch_end
    im = imread(imdir{j});
    im = single(im);
    im = preprocess(im);
    ims(:,:,:,j-batch_start+1) = im;
  end
  batches{batch} = ims;
end

fprintf('compute features ...\n');
feat_dim = -1;
feat = [];
curr = 1;
for j = 1:length(batches)
fprintf('batch: %d/%d\n',j,length(batches));
  f = net.forward(batches(j));
  f = f{1};
  f = f(:);
  if j == 1
    feat_dim = length(f)/batch_size;
    feat = zeros(num_im, feat_dim, 'single');
  end
  f = reshape(f, [feat_dim batch_size]);
  if j == length(batches)
    if batch_padding > 0
      f = f(:, 1:end-batch_padding);
    end
  end
  feat(curr:curr+size(f,2)-1,:) = f';
  curr = curr + batch_size;
end
train_data = feat;
train_feat = sparse(double(feat));
train_label = double(label);

[imdir,label] = textread('cifar_test.txt','%s %d');
num_im = length(imdir);

fprintf('preprocess ...\n');
num_batches = ceil(num_im / batch_size);
batch_padding = batch_size - mod(num_im, batch_size);
if batch_padding == batch_size
  batch_padding = 0;
end
batches = cell(num_batches, 1);
for batch = 1:num_batches
  batch_start = (batch-1)*batch_size+1;
  batch_end = min(num_im, batch_start+batch_size-1);
  ims = zeros(crop_size, crop_size, 3, batch_size, 'single');
  for j = batch_start:batch_end
    im = imread(imdir{j});
    im = single(im);
    im = preprocess(im);
    ims(:,:,:,j-batch_start+1) = im;
  end
  batches{batch} = ims;
end

fprintf('compute features ...\n');
feat_dim = -1;
feat = [];
curr = 1;
for j = 1:length(batches)
fprintf('batch: %d/%d\n',j,length(batches));
  f = net.forward(batches(j));
  f = f{1};
  f = f(:);
  if j == 1
    feat_dim = length(f)/batch_size;
    feat = zeros(num_im, feat_dim, 'single');
  end
  f = reshape(f, [feat_dim batch_size]);
  if j == length(batches)
    if batch_padding > 0
      f = f(:, 1:end-batch_padding);
    end
  end
  feat(curr:curr+size(f,2)-1,:) = f';
  curr = curr + batch_size;
end
test_data = feat;
test_feat = sparse(double(feat));
test_label = double(label);

fprintf('training ...\n');
svm_model = train(train_label,train_feat,['-s 0 -q']);
fprintf('testing ...\n');
[predicted_label, accuracy, decision_values] = predict(test_label, test_feat, svm_model,['-q']);
fprintf('acc: %f\n',accuracy(1));

caffe.reset_all();
