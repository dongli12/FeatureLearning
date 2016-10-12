#!/bin/bash

for i in 1 5 10 50 100 500
do
#echo $i
    mkdir -p snapshot_$i
    cp net.prototxt net_$i.prototxt
    cp solver.prototxt solver_$i.prototxt
    sed -i 's/{ims_perC}/'$i'/g' net_$i.prototxt
    sed -i 's/{ims_perC}/'$i'/g' solver_$i.prototxt
    ~/caffe/build/tools/caffe train \
	-solver `pwd`solver_$i.prototxt \
	-weights ../train_model_iter_50000.caffemodel  \
	2>&1 | tee train_$i.log
done
