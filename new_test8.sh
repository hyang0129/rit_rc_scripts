#!/bin/bash -l

#SBATCH --job-name=nb8886new		# Name for your job
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
#SBATCH --cpus-per-task=16		# Number of CPUs per task
#SBATCH --mem-per-cpu=5g		# Memory per CPU
#SBATCH --gres=gpu:a100:1

echo "Setting Up Jupyter Server"

echo "Loading Packages"

source ~/conda/etc/profile.d/conda.sh
conda activate ml

CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib

spack load /arwp2px # cuda 12.4 / gcc 13.2
spack load /ujqlkat # gcc 13.2
#xcjeomb

echo "Launching Jupyter Server"
jupyter lab --ip=0.0.0.0 --no-browser --port=8886