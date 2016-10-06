%  Copyright (c) 2014, Karen Simonyan
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).

clear;

isCluster = false;
% isCluster = true;

%% aligned LFW images, unrestricted setting, joint low-rank metric-similarity learning
 
prms.setName = 'lfw_aligned';
prms.expName = 'SIFT_1pix_PCA64_GMM512';
prms.trainSettingName = 'unrest';
 
prms.modelType = 'metric_sim';
gammaSet = 0.25;
gammaBiasSet = 10;

prms.descName = 'poolfv';
prms.useMirrorFeat = true;
 
%% aligned LFW images, unrestricted setting, low-rank metric learning
 
% prms.setName = 'lfw_aligned';
% prms.expName = 'SIFT_1pix_PCA64_GMM512';
% prms.trainSettingName = 'unrest';
% 
% prms.modelType = 'metric';
% gammaSet = 0.25;
% gammaBiasSet = 1;
% 
% prms.descName = 'poolfv';
% prms.useMirrorFeat = true;

%% aligned LFW images, unrestricted setting, L2 distance between projected FVs
% the projection is learnt using the low-rank metric learning settings above, so the results are the same

% prms.setName = 'lfw_aligned';
% prms.expName = 'SIFT_1pix_PCA64_GMM512';
% prms.trainSettingName = 'unrest';
% 
% prms.modelType = 'L2';
%     
% prms.descName = 'poolfv_proj';
% prms.useMirrorFeat = true;

%% LFW-funneled images, restricted setting

% prms.setName = 'lfw_funneled';
% prms.expName = 'SIFT_1pix_PCA64_GMM512_restricted';
% prms.trainSettingName = 'rest';
% 
% prms.modelType = 'diag_metric';
% prms.lambdaSet = 1e-8;
% 
% prms.descName = 'poolfv';
% prms.useMirrorFeat = true;

%% unaligned LFW images (cropped Viola-Jones detection), unrestricted setting, low-rank metric learning

% prms.setName = 'lfw_vj';
% prms.expName = 'SIFT_1pix_PCA64_GMM512';
% prms.trainSettingName = 'unrest';
% 
% prms.modelType = 'metric';
% prms.gammaSet = 0.25;
% prms.gammaBiasSet = 10;
% 
% prms.descName = 'poolfv';
% prms.useMirrorFeat = true;

%% unaligned LFW images (cropped Viola-Jones detection), unrestricted setting, L2 distance between projected FVs
% the projection is learnt using the low-rank metric learning settings above, so the results are the same

% prms.setName = 'lfw_vj';
% prms.expName = 'SIFT_1pix_PCA64_GMM512';
% prms.trainSettingName = 'unrest';

% prms.modelType = 'L2';
% 
% prms.descName = 'poolfv_proj';
% prms.useMirrorFeat = true;




%%
if isCluster
    
    if isequal(prms.modelType, 'metric') || isequal(prms.modelType, 'metric_sim')
        
        fprintf('FV PCA-whitening...\n');
        JD1 = batch('face_desc.manager.learn.learn_fv_dimred', 'matlabpool', 10, 'workspace', prms); 
        wait(JD1);        
    end
    
    fprintf('Learning models...\n');
    JD2 = batch('face_desc.manager.learn.learn_metric', 'matlabpool', 40, 'workspace', prms); 

    wait(JD2);
    diary(JD2);

else
    
    % copy params struct to the current workspace & run the code
    prmsName = fieldnames(prms);
    
    for idxName = 1:numel(prmsName)
        assignin('base', prmsName{idxName}, prms.(prmsName{idxName}));
    end
    
    % FV PCA-whitening (for learning initialisation)
    if isequal(prms.modelType, 'metric') || isequal(prms.modelType, 'metric_sim')
    
        fprintf('FV PCA-whitening...\n');
        face_desc.manager.learn.learn_fv_dimred;
    end
    
    % discriminative FV dimensionality reduction
    fprintf('Learning models...\n');
    face_desc.manager.learn.learn_metric;
end
