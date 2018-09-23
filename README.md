# Unsupervised Visual Representation Learning by Graph-based Consistent Constraints (ECCV 2016)

This is the research code for the paper:

[Dong Li](https://sites.google.com/site/lidonggg930), [Wei-Chih Hung](https://hfslyc.github.io/), [Jia-Bin Huang](https://filebox.ece.vt.edu/~jbhuang/), [Shengjin Wang](http://www.ee.tsinghua.edu.cn/publish/eeen/3784/2010/20101219115601212198627/20101219115601212198627_.html), [Narendra Ahuja](http://vision.ai.illinois.edu/ahuja.html), and [Ming-Hsuan Yang](http://faculty.ucmerced.edu/mhyang/). "Unsupervised Visual Representation Learning by Graph-based Consistent Constraints" In Proceedings of European Conference on Computer Vision (ECCV), 2016

We take the CIFAR10 dataset as an example to test our unsupervised constraint mining approach in this code. Our mined constraints and trained model on ImageNet in the unsupervised manner can be found here: 

[ImageNet_unsup.zip](https://drive.google.com/open?id=0BynEQyOSGRoSaTluaEpGcWRNa1E)

[Project page](https://sites.google.com/site/lidonggg930/feature-learning)

### Citation

If you find the code and pre-trained models useful in your research, please consider citing:

    @inproceedings{Li-ECCV-2016,
        author = {Li, Dong and Hung, Wei-Chih and Huang, Jia-Bin and Wang, Shengjin and Ahuja, Narendra and Yang, Ming-Hsuan},
        title = {Unsupervised Visual Representation Learning by Graph-based Consistent Constraints},
        booktitle = {European Conference on Computer Vision},
        year = {2016},
        volume = {},
        number = {},
        pages = {}
    }

### System Requirements

- MATLAB (tested with R2014a on 64-bit Linux)
- Caffe

### Installation

1. Download and unzip the project code. Unzip `features.zip` which is used to extract Fisher Vectors. 

2. Download the [VLFeat library](http://www.vlfeat.org/download/vlfeat-0.9.13-bin.tar.gz) and extract all the files into the directory named `vlfeat`. Download the [LIBLINEAR library](http://www.csie.ntu.edu.tw/~cjlin/cgi-bin/liblinear.cgi?+http://www.csie.ntu.edu.tw/~cjlin/liblinear+zip) and extract all the files into the directory named `liblinear`. Install the two dependencies.

3. Install Caffe. Please follow the [Caffe installation instructions](http://caffe.berkeleyvision.org/installation.html) to install dependencies and then compile Caffe:

    ```
    # We call the root directory of the project code `FL_ROOT`.
    cd $FL_ROOT/caffe
    make all -j8
    make pycaffe
    make matcaffe
    ```

4. Download the [CIFAR10 dataset](https://www.cs.toronto.edu/~kriz/cifar-10-matlab.tar.gz). Extract all the files into `$FL_ROOT/datasets/CIFAR10`. 

5. Download the [pre-trained ImageNet model](http://dl.caffe.berkeleyvision.org/bvlc_alexnet.caffemodel) and put it into `$FL_ROOT/models`.

6. Install the project.

    ```
    cd $FL_ROOT
    # Start MATLAB
    matlab
    >> startup
    ```

### Usage

1. Extract low-level features (Fisher Vectors). 

    ```
    >> prepare_data
    >> extract_features
    ```
   Note:
   1) You may set different params to extract FV features for different datasets, e.g., totalFeatLimit and numImg in compute_dense.m.
   2) We resize the image to 256*256 to extract FV features (L32 of compute_dense.m in feature.zip).
   3) It takes a few days to extract features for the ImageNet 1M images with parallelization.

2. Mine constraints.

    ```
    >> extract_pairs_pos
    >> extract_pairs_neg
    ```

3. Train the Siamese network for binary classification.

    ```
    >> prepare_train
    cd $FL_ROOT
    sh train.sh
    ```

4. Test for image classification.

    ```
    >> test_cifar
    ```
    
