==============================================================
Fisher Vector Face Descriptor

Karen Simonyan, Omkar Parkhi, Andrea Vedaldi, Andrew Zisserman 
Visual Geometry Group, University of Oxford
==============================================================

--------
Overview
--------

This package contains the MATLAB source code for learning, computation, and evaluation of the Fisher Vector Face (FVF) descriptors.
The algorithm details can be found in [1]. Apart from the source code, we also release an extensive set of pre-computed data packages, 
which can be used to exactly reproduce the results reported in Table 2 of [1]. 

The source code and data packages can be downloaded from: http://www.robots.ox.ac.uk/~vgg/software/face_desc/

The source code is released under the terms of the BSD license. Please cite [1] if you use the code or the data.
If you have any questions regarding the package, please contact Karen Simonyan <karen@robots.ox.ac.uk>

------------
Dependencies
------------

The source code depends on the publicly available VLFeat library, which should be in the MATLAB path.
In our experiments, we used MATLAB r2011a and VLFeat 0.9.13. The latter can be downloaded from
http://www.vlfeat.org/download/vlfeat-0.9.13-bin.tar.gz

The FVF descriptors are learnt and evaluated on the Labeled Faces in the Wild (LFW) dataset [2].
The LFW and LFW-funneled datasets can be downloaded from the LFW organisers' website:
http://vis-www.cs.umass.edu/lfw/lfw.tgz
http://vis-www.cs.umass.edu/lfw/lfw-funneled.tgz
They should be unpacked into "../data/images/lfw/" and "../data/images/lfw_funneled/" respectively (relative to the source code directory).

-------------
Data Packages
-------------

We release the learnt descriptor models, and pre-computed descriptors for the following three evaluation settings:

1. LFW-Unrestricted setting, where the original (unaligned) LFW images are aligned using the method of [3]. Our method achieves 93.03% 
verification accuracy using joint low-rank metric and similarity learning [1], and 91.32% using a low-rank metric only (which can be seen
as discriminative dimensionality reduction).

2. LFW-Unrestricted setting, where unaligned Viola-Jones face detections in the original LFW images are used. Our method achieves 90.68%
accuracy using low-rank metric learning. We hope that such pre-learnt low-dimensional descriptors of unaligned face images can find 
their application beyond the LFW benchmark.

3. LFW-restricted setting, where the pre-aligned LFW-funneled images are used. In this case, our method achieves 87.47% accuracy [1] using
diagonal pseudo-metric learning.

For each of the three settings above and the ten dataset splits of LFW, we release:

*  the source code for face image pre-processing (alignment and/or cropping) as used in [1];

*  Fisher vector computation models (PCA projection for dense SIFT features and a GMM codebook);

*  discriminatively learnt face verification models (Setting 1: joint low-rank metric and similarity, and low-rank metric alone; 
   Setting 2: low-rank metric; Setting 3: diagonal pseudo-metric);

*  high-dimensional Fisher vector descriptors (Setting 1 only, due to the large size) and low-dimensional projected Fisher vector descriptors 
   (Settings 1 and 2);

*  face verification scores.

All downloaded packages should be unpacked into the same directory.

It is possible to re-compute all models and scores starting from the package with the dataset splits (shared.tar). This, however, can be a 
time-consuming process, so for convenience we have released the interim data, as well as the final face verification scores.

-----
Usage
-----

1. Initialisation

In startup.m, make sure that the path to the VLFeat installation is specified correctly.

The data packages (mentioned above) are assumed to be unpacked into "../data" directory. This can be changed by setting "familyDir" in 
"+face_desc/+config/+feat_config.m" and "+face_desc/+config/+learn_config.m" The former is the configuration file for feature computation, the 
latter is the configuration file for metric learning.


2. Image pre-processing

Before face descriptor computation, the images should be aligned and cropped (Setting 1) or cropped (Settings 2 and 3).
This can be carried out by running "face_desc.prep_img.align_crop_lfw", "face_desc.prep_img.crop_lfw", or "face_desc.prep_img.crop_lfw_funneled"
for Settings 1-3 respectively. This exactly reproduces the pre-processing used in [1].


3. Fisher Vector (FV) computation

Run "launch_fv_comp" to compute the high-dimensional Fisher vector face descriptors.
The flag "isCluster" defines if the computation will be performed in the cluster environment or on a local machine.

In general, this involves the following steps:
i) computing a subset of dense SIFT features ("face_desc.manager.face_descriptor.compute_dense")
ii) computing SIFT PCA and GMM on the subset ("face_desc.manager.face_descriptor.learn_pca_gmm")
iii) computing high-dimensional Fisher vector face representation ("face_desc.manager.face_descriptor.compute_fv")

If one of the above is already computed (or obtained from the released data packages), the corresponding step is skipped.


4. Discriminative metric learning

Run "launch_learn" to learn and evaluate the distance function for FV descriptors. 
Three learning formulations are supported (see [1] for details):

i) A low-rank Mahalanobis metric, which can also be seen as the Euclidean (L2) distance in the low-dimensional subspace of projected Fisher vectors. 
   It is selected by setting "modelType = 'metric'".

ii) A combination of a low-rank Mahalanobis metric and a low-rank inner product. It is selected by setting "modelType = 'metric_sim'".

iii) A diagonal pseudo-metric (without dimensionality reduction). It is selected by setting "modelType = 'diag_metric'".

In the header of "launch_learn.m" one can find a number of pre-defined configurations for different training scenarios. Uncomment one of them to run 
the corresponding experiment. 

If the models or verification scores are already computed (or obtained from the released data packages), the verification results will be printed out 
immediately.

The training functions utilise pre-computed training image pairs, which are provided in the "shared.tar" data package ("../data/shared/train_data/").
The code for computing these pairs can be found in
"face_desc.manager.annotations.pairs.make_pairs_rest_eval" - for the restricted LFW setting;
"face_desc.manager.annotations.pairs.make_pairs_unrest_eval" - for the unrestricted LFW setting.
Running the code is not required if you use the pre-computed pairs.


5. Low-dimensional face descriptor computation.

To compute low-dimensional FVF descriptors, one should project high-dimensional Fisher vectors (computed at step 2) using the discriminative linear 
projection learnt at step 3. This can be done by running the script: "face_desc.manager.face_descriptor.compute_fv_proj".
Low-dimensional FVF descriptors are also provided in the released data packages.

The projected FVs should be compared using the Euclidean distance by setting "modelType = 'L2'" in "launch_learn". This leads to the same verification
results as comparing unprojected high-dimensional FVs using the learnt Mahalanobis metric ("modelType = 'metric'" setting in "launch_learn").

The process of computing the low-dimensional FVF representation is also illustrated in the example script 
"face_desc.manager.face_descriptor.compute_fv_single_img".


6. Visualisation

To visualise the learnt dimensionality reduction model (see Fig.2 in [1]), run "vis.vis_gmm"

----------
References
----------

[1] K. Simonyan, O. M. Parkhi, A. Vedaldi, A. Zisserman
Fisher Vector Faces in the Wild  
British Machine Vision Conference, 2013 
http://www.robots.ox.ac.uk/~vgg/publications/2013/Simonyan13/simonyan13.pdf

[2] G. B. Huang, M. Ramesh, T. Berg, E. Learned-Miller
Labeled faces in the wild: A database for studying face recognition in unconstrained environments.
Technical Report 07-49, University of Massachusetts, Amherst, 2007.

[3] M. Everingham, J. Sivic, A. Zisserman
Taking the Bite out of Automatic Naming of Characters in TV Video  
Image and Vision Computing, Volume 27, Number 5, 2009 
