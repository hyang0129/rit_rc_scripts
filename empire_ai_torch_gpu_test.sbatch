#!/bin/bash
#SBATCH --job-name=torch-gpu-test
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=00:10:00
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err

set -euo pipefail

echo "JobID: $SLURM_JOB_ID"
echo "Node:  $SLURMD_NODENAME"
echo "CWD:   $(pwd)"

# Option B) Your venv (recommended for a simple tutorial)
source ~/venvs/torch/bin/activate

# Diagnostics (optional but helpful)
command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi || true
python - <<'PY'
import torch
print("Torch:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())
PY

# Run inside the allocation
srun --cpu-bind=cores python -u torch_gpu_test.py
