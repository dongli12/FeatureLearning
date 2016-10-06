%  Copyright (c) 2014, Karen Simonyan
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).

clear;

startup;

face_desc.config.feat_config;
% subset of dense SIFT features
face_desc.manager.face_descriptor.compute_dense;
% SIFT-PCA & GMM learning
face_desc.manager.face_descriptor.learn_pca_gmm;
%FV computation
face_desc.manager.face_descriptor.compute_fv;