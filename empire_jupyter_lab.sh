#!/bin/bash -l

# Parse port argument (default: 8887)
PORT=${1:-8887}

#SBATCH --job-name=jupyter_empire_PORT		# Name for your job (PORT will be replaced)
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

# Update job name with actual port
sacct --format=JobID,JobName -j ${SLURM_JOB_ID} 2>/dev/null || true
scontrol update JobId=${SLURM_JOB_ID} JobName=jupyter_empire_${PORT} 2>/dev/null || true

echo "Setting Up Jupyter Server on Empire AI (Port: ${PORT})"

echo "Loading Packages"

source ~/miniconda3/etc/profile.d/conda.sh
conda activate ml

# Set up CUDA libraries if needed
CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib

echo "Launching Jupyter Lab on port ${PORT}"
jupyter lab --ip=0.0.0.0 --no-browser --port=${PORT}
