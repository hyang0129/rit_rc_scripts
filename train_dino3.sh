#!/bin/bash -l

#SBATCH --comment="Testing Job"		# Comment for your job

#SBATCH --account=icmab		# Project account to run your job under
#SBATCH --partition=tier3		# Partition to run your job on

#SBATCH --output=%x_%j.out		# Output file
#SBATCH --error=%x_%j.err		# Error file

#SBATCH --mail-user=hy3134@rit.edu	# Email address to notify
#SBATCH --mail-type=END			# Type of notification emails to send

#SBATCH --time=0-72:00:00		# Time limit
#SBATCH --nodes=1			# How many nodes to run on
#SBATCH --ntasks=1			# How many tasks per node
#SBATCH --cpus-per-task=10		# Number of CPUs per task
#SBATCH --mem-per-cpu=10g		# Memory per CPU
#SBATCH --gres=gpu:a100:1

start_time=$(date +%s)

echo "Setting Up Jupyter Server"

echo "Loading Packages"

source ~/conda/etc/profile.d/conda.sh
conda activate

export XLA_FLAGS=--xla_gpu_cuda_data_dir=/home/hy3134/conda/lib
# note that XLA flags dir must resemble /lib/nvvm/libdevice/libdevice.10.bc

CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib

spack load /igzaycn # cuda 11.8
#spack load /dr4ipev # gcc 12.2

#spack load /t7uxsmp # gcc 11.2 seems to already be loaded but needs to be explicity reloaded

spack load gcc@11.2.0

#echo "Launching Jupyter Server"
#jupyter lab --ip=0.0.0.0 --no-browser --port=8886

echo '[Begin Tasks]'

cd notebook_split_ood/SubclassOOD/OpenOOD-main/



for i in "" "_1" "_2" "_3" "_4"; do
    python train_cross_entropy.py --dataset "fashion$i" --training_method dino
done

for i in "" "_1" "_2" "_3" "_4"; do
    python train_cross_entropy.py --dataset "plant$i" --training_method dino
done

for i in "" "_1" "_2" "_3" "_4"; do
    python train_cross_entropy.py --dataset "food$i" --training_method dino
done



# End time
end_time=$(date +%s)

# Calculate duration
duration=$((end_time - start_time))

echo "Execution time: ${duration} seconds"


echo '[Finished Tasks]'