# designed for single GPU

import nvidia_smi
import pandas as pd
import os
import time


nvidia_smi.nvmlInit()
deviceCount = nvidia_smi.nvmlDeviceGetCount()



def check_device_stats(index = 0):

    handle = nvidia_smi.nvmlDeviceGetHandleByIndex(index)
    util = nvidia_smi.nvmlDeviceGetUtilizationRates(handle)
    mem = nvidia_smi.nvmlDeviceGetMemoryInfo(handle)

    to_print = (f"|Device {index}| Mem Free: {mem.free/1024**2:5.2f}MB / {mem.total/1024**2:5.2f}MB | gpu-util: {util.gpu:3.1%} | gpu-mem: {util.memory:3.1%} |")

    mem_free = mem.free/1024**2
    mem_total = mem.total/1024**2
    gpu_util = util.gpu
    mem_util = util.memory

    return mem_free, mem_total, gpu_util, mem_util, to_print


def write_log(path_to_log = 'gpu_util.log', gpu_index = 0):

    mem_free, mem_total, gpu_util, mem_util, to_print = check_device_stats(gpu_index)

    data =[ {'mem_free' : mem_free,
            'mem_total' : mem_total,
            'gpu_util' : gpu_util,
            'mem_util' : mem_util,
            'datetime' : pd.Timestamp.now() }]

    df = pd.DataFrame(data)

    if not os.path.exists(path_to_log):
        df.to_csv(path = path_to_log, index=False, header=False)

    else:
        df.to_csv(path = path_to_log, mode='a', index=False, header=False)


def check_utilization_loop(path_to_log = 'gpu_util.log', gpu_index = 0):

    gpu_in_use = True

    while gpu_in_use:
        time.sleep(60)

        write_log(path_to_log, gpu_index)

        data = pd.read_csv(path_to_log).tail(31)

        max_utilization = data.gpu_util.max()


        if len(data) > 30 and max_utilization < 0.1:
            gpu_in_use is False

        print('GPU IN USE : ', gpu_in_use , max_utilization, pd.Timestamp.now())


check_utilization_loop()





