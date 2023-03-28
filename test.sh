#!/bin/bash -l

#SBATCH --job-name=testJob		# Name for your job
#SBATCH --comment="Testing Job"		# Comment for your job

#SBATCH --account=ngafid		# Project account to run your job under
#SBATCH --partition=tier3		# Partition to run your job on

#SBATCH --output=%x_%j.out		# Output file
#SBATCH --error=%x_%j.err		# Error file

#SBATCH --mail-user=hy3134@rit.edu	# Email address to notify
#SBATCH --mail-type=END			# Type of notification emails to send

#SBATCH --time=0-02:00:00		# Time limit
#SBATCH --nodes=1			# How many nodes to run on
#SBATCH --ntasks=1			# How many tasks per node
#SBATCH --cpus-per-task=4		# Number of CPUs per task
#SBATCH --mem-per-cpu=10g		# Memory per CPU
#SBATCH --gres=gpu:a100:1



echo "Setting Up Jupyter Server"

hostname				# Run the command hostname

echo "Loading Spack Package"

spack load gcc
spack load /4oiwjzp # jupyter server w py3.10
spack load /mwfp7xe # cuda 11.7





echo "Launcher Jupyter Server"
jupyter notebook --ip=0.0.0.0 --no-browser &

echo "Installing Requirements"
pip install -r requirements.txt

echo "Running loop to send email"
python send_email.py

echo "Running GPU Usage Check"
python check_gpu_usage.py

echo 'Exiting Due to Insufficient GPU Usage'





