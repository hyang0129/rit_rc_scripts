# Empire AI

## FAQ

### What is Empire AI?

[Empire AI](https://www.empireai.edu/) is a New York State sponsored consortium that gives member institutions (including RIT) access to large-scale compute for responsible AI and HPC research.

### Who can use Empire AI?

Sponsored Research Services (SRS) and the Office of the Vice President for Research (OVPR) put out calls for proposals and approve AI-based research projects for access to Empire AI. **Only projects that have been approved by SRS/OVPR can access Empire AI.**

### What resources are available in the Empire AI cluster?

Empire AI is currently in the **Alpha** phase. **Beta** is the next primary expansion phase (a second system) intended to increase capacity and performance dramatically. Alpha and Beta are expected to share core infrastructure like login/data-transfer nodes, storage, and Slurm. [Hardware overview](https://empireai.freshdesk.com/support/solutions/articles/157000363466-alpha-beta-hardware-early-2026-).

### What happens after my Empire AI allocation is approved?

Access to Empire AI through RIT is coordinated through Sponsored Research Services (SRS). Once your allocation is approved, you will be provided information on how to schedule an onboarding session with Research Computing. **Onboarding is mandatory.** Your Empire AI account (different from your RIT account) will be created during onboarding.

### How do I get support for Empire AI?

Empire AI has their own help desk for support requests: [empireai.freshdesk.com/support/home](https://empireai.freshdesk.com/support/home)

Please **DO NOT** submit tickets to the RIT Service Center for Empire AI support. Research Computing only provides onboarding and limited support for login issues with Empire AI. The Research Computing Administrators do not have administrative access to Empire AI; you must go through the Empire AI help desk for support.

### Where can I find Empire AI documentation?

[Click here](https://empireai.freshdesk.com/support/home).

### How do I login to Empire AI?

After your Empire AI account (different from your RIT account) is created during onboarding, you can login with the following command:

```bash
$ ssh <empire_ai_username>@alpha1.empireai.edu
```

During onboarding, you will set up a multifactor authentication (MFA) mechanism. You will be required to use your MFA code when logging into Empire AI.

**Note:** Empire AI does not currently have a web portal like OnDemand. You must login via SSH.

### What storage is available on Empire AI?

There are three storage locations on the Empire AI cluster. [Click for details](https://empireai.freshdesk.com/support/solutions/articles/157000175046-empire-ai-alpha-storage).

Note that Empire AI does not provide Project Directories. You can [follow these instructions](https://empireai.freshdesk.com/support/solutions/articles/157000010953-how-can-i-share-data-with-other-users-) to share data with your collaborators on the Empire AI cluster.

### How do I transfer data to the Empire AI cluster?

From your laptop to Empire AI:

```bash
$ scp -r ./myproject <empire_ai_username>@alpha1.empireai.edu:~
```

From Empire AI to your laptop:

```bash
$ scp -r <empire_ai_username>@alpha1.empireai.edu:~/results ./results
```

You can run the same commands from the RC cluster to transfer data from the RC cluster to Empire AI, and vice versa.

**Note:** You will need to authenticate with your MFA code each time you transfer data to/from Empire AI.

**Note:** Other linux commands, such as `sftp` and `rsync` should also work from transferring data.

### Can I use VSCode or other IDEs on the Empire AI cluster?

**No.** The Empire AI cluster is intended solely for computation.

### How do I access software on the Empire AI cluster?

Empire AI provides some basic software to researchers. You can see what software is available by running:

```bash
$ module avail
```

You can load software by running:

```bash
$ module load <software_name>
```

You can see what software is loaded by running:

```bash
$ module list
```

**Note:** You will have to re-load software using `module load` each time you log into Empire AI, and in your Slurm scripts.

**Note:** Empire AI does not provide software support, nor does Research Computing provide software support on the Empire AI cluster. You will likely have to install your own software (_e.g._ conda, pip, containers). We recommend choosing one package manager and sticking with it to avoid conflicts between package managers.

### How do I submit jobs on the Empire AI cluster?

The Empire AI cluster runs Slurm, just like the RC cluster. However, the `--account` and `--partition` directives in your Empire AI Slurm scripts will not be the same as on the RC cluster.

Documentation:
- [Empire AI Accounts](https://empireai.freshdesk.com/support/solutions/articles/157000010768-how-do-i-submit-jobs-#Partitions)
- [Empire AI Allocations & Job Scheduling](https://empireai.freshdesk.com/support/solutions/articles/157000010908-institutional-allocations-and-job-scheduling-preemption)
- [Empire AI Paritions](https://empireai.freshdesk.com/support/solutions/articles/157000168778-slurm-partitions-queues-)

### What are Service Units?

Each member institution of Empire AI is granted a pool of Service Units. Each project approved to use Empire AI resources is granted a certain number of Service Units.

Every job you run on the Empire AI uses Service Units. [Breakdown of Service Units](https://empireai.freshdesk.com/support/solutions/articles/157000363467-service-units-and-allocations-for-alpha-beta).

**Note:** Empire AI is currently in the **Alpha** phase. Service Units will be introduced in **Beta**.

### How do I monitor my jobs on the Empire AI cluster?

Similar to the RC cluster, standard Slurm commands are available.

See what jobs you have in the queue:

```bash
$ squeue --me
```

See when your jobs will start:

```bash
$ squeue --me --start
```

See details on your submitted jobs:

```bash
$ scontrol show job <job_id>
```

See resource utilization while your jobs are running:

```bash
$ sstat -j <job_id> --format=JobID,AveCPU,AveRSS,MaxRSS,AveVMSize,MaxVMSize
```

See resource utilization after your jobs are complete:

```bash
$ sacct -j <job_id> --format=JobID,JobName%20,State,Elapsed,AllocCPUS,ReqMem,MaxRSS,NodeList
```

**Note:** Commands like `htop` and `nvidia-smi` are also available on the Empire AI cluster.

**Note:** Empire AI does not have a grafana dashboard to view resource utilization graphs (yet).

### What are project reports?

One month after an Empire AI allocation ends, PIs must submit a 1-page non-technical report, and 1-slide presentation on a project highlight. [Project Report Details](https://empireai.freshdesk.com/support/solutions/articles/157000363495-project-reports-and-highlights).

### How do I cite Empire AI and Research Computing in my papers?

- [Empire AI](https://empireai.freshdesk.com/support/solutions/articles/157000359451-acknowledging-use-of-empire-ai-in-a-paper-or-presentation)
- [Research Computing](https://mirrors.rit.edu/publications/#citation--acknowledgment)

## Empire AI Job Tutorial

### Step 1: Create a Working Directory

```bash
$ mkdir -p ~/tutorials/torch-gpu
$ cd ~/tutorials/torch-gpu
```

### Step 2: Create a Minimal PyTorch GPU Test Job

This script prints GPU visibility and runs a quick GPU matrix multiply.

```python
cat > torch_gpu_test.py <<'PY'
import os
import torch

print("Host:", os.uname().nodename)
print("CUDA_VISIBLE_DEVICES:", os.environ.get("CUDA_VISIBLE_DEVICES"))
print("Torch:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())

if not torch.cuda.is_available():
    raise SystemExit("No CUDA GPU visible to this job.")

print("CUDA (torch):", torch.version.cuda)
print("GPU count:", torch.cuda.device_count())
for i in range(torch.cuda.device_count()):
    print(f"GPU {i}:", torch.cuda.get_device_name(i))

# quick compute to prove GPU execution
a = torch.randn(4096, 4096, device="cuda")
b = torch.randn(4096, 4096, device="cuda")
c = a @ b
print("Matmul ok, mean:", c.mean().item())
PY
```

### Step 3: Set Up a Python Environment

If you already have a working Python environment with torch installed, you can skip this section.

```bash
$ module load python
$ python -m venv ~/venvs/torch
$ source ~/venvs/torch/bin/activate
$ pip install --upgrade pip
$ pip install torch
$ pip install numpy
```

**Sanity Check:** Make sure python is working properly (don't worry if CUDA returns false):

```bash
$ python -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
```

### Step 4: Create a Slurm Job Script

```bash
cat > torch_gpu_rit.sbatch <<'SBATCH'
#!/bin/bash
#SBATCH --job-name=torch-gpu-test
#SBATCH --partition=rit
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

# -------------------------
# Python setup: choose ONE
# -------------------------

# Alpha provides modules (uncomment if needed)
# module purge
# module load python
# module load cuda   # only if your site requires it for torch to see GPUs

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
SBATCH
```

### Step 5: Submit Your Job

```bash
$ sbatch torch_gpu_rit.sbatch
```

---

**Help:** If there are any further questions, or there is an issue with the documentation, please submit a ticket or contact us on Slack for additional assistance.

**Tags:** slurm, about, maintenance, empire ai
