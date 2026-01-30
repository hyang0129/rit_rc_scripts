#!/bin/bash -l

#SBATCH --job-name=jupyter_empire		# Name for your job
#SBATCH --comment="Jupyter Lab on Empire AI"	# Comment for your job

#SBATCH --account=rit				# Empire AI account
#SBATCH --partition=rit				# Partition to run your job on

#SBATCH --output=%x_%j.out			# Output file
#SBATCH --error=%x_%j.err			# Error file

#SBATCH --mail-user=hy3134@rit.edu		# Email address to notify
#SBATCH --mail-type=END				# Type of notification emails to send

#SBATCH --time=3-00:00:00			# Time limit: 3 days
#SBATCH --nodes=1				# How many nodes to run on
#SBATCH --ntasks=1				# How many tasks per node
#SBATCH --cpus-per-task=16			# Number of CPUs per task
#SBATCH --mem-per-cpu=6g			# Memory per CPU: 6GB
#SBATCH --gres=gpu:1				# 1 GPU

echo "Setting Up Jupyter Server on Empire AI"

echo "Loading Packages"

source ~/miniconda3/etc/profile.d/conda.sh
conda activate ml

# Set up CUDA libraries if needed
CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib

echo "Launching Jupyter Lab"
jupyter lab --ip=0.0.0.0 --no-browser --port=8887
