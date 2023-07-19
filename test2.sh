#!/bin/bash -l


echo "Setting Up Jupyter Server"

echo "Loading Packages"

source ~/conda/etc/profile.d/conda.sh
conda activate

export XLA_FLAGS=--xla_gpu_cuda_data_dir=/home/hy3134/conda/lib
# note that XLA flags dir must resemble /lib/nvvm/libdevice/libdevice.10.bc
# this needs to be set to your own home drive that contains the libdevice.10.bc, but only relevant for tensorflow
# you should be able to skip this XLA flag completely if we only doing pytorch

CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib

spack load /igzaycn # cuda 11.8
spack load /dr4ipev # gcc 12.2


echo "Launching Jupyter Server"
jupyter lab --ip=0.0.0.0 --no-browser --port=8888