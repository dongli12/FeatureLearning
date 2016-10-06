./caffe/build/tools/caffe train -gpu 0 -solver solver_cifar_alexnet.prototxt -weights models/bvlc_alexnet.caffemodel 2>&1 | tee log_train_cifar.txt
