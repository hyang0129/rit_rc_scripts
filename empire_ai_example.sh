#!/bin/bash -l
# Configuration Options
#SBATCH --account=rit
#SBATCH --partition=rit
#SBATCH --job-name=WordCounts
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --time=0-00:10:00
#SBATCH --mem=1g
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
# Load Software
module load software_name
# Your Code
python3 countWords.py