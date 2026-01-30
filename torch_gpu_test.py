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
