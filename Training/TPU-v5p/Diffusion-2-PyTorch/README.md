# Instructions for training Stable Diffusion 2 on TPU v5p


This user guide provides a concise overview of the essential steps required to run StableDiffusion 2.0 base training on Cloud TPUs.


## Environment Setup

The following setup assumes to run the training job with StableDiffusion 2.0 base on GCE TPUs using the docker image from [this registery]( us-central1-docker.pkg.dev/tpu-pytorch/docker/development/pytorch-tpu-diffusers:v1), the docker image uses the pytorch and torch_xla nightly build from 09/05 and has all the package dependency installed. It cloned the git repo from [https://github.com/pytorch-tpu/diffusers (commit f08dc9)](https://github.com/pytorch-tpu/diffusers/tree/f08dc92db9d7fd7d8d8ad4efcdfee675e2cd26f2) in order to run hugging face stable diffusion on TPU. Please follow corresponding TPU generation's user guide to setup the GCE TPUs first. All the command below should run from your own machine (not the TPU host you created).

### Setup Environment of Your TPUs
Please replace all your-* with your TPUs' information.
```
export TPU_NAME=your-tpu-name
export ZONE=your-tpu-zone
export PROJECT=your-tpu-project
```

### Simple Run Command
git clone and navigate to this README repo and run training script:
```bash
git clone  --depth 1 https://github.com/gclouduniverse/reproducibility.git/
cd reproducibility/Training/TPU-v5p/Diffusion-2-PyTorch
bash benchmark.sh
```
`benchmark.sh` script will upload 1) environment parameters in `env.sh`,  2) docker launch script in `host.sh` and 3) python training command in `train.sh` into all TPU workers, and starts the training afterwards. When all training steps complete, it will print out the average step time. You shall see the performance metric in the terminal as
```
[worker :x] Average step time: ...
```
, which tells the average step time for each batch run of each worker. In addition,  it will copy the profile back to current folder under *profile/* and the trained model in safetensor format under *output/*.


### Environment Envs Explained

To make it simple, we suggest only change the following to env variables in env.sh:
*   `PER_HOST_BATCH_SIZE`:Batch size for each host/worker. High number can cause out of memory issue.
*   `TRAIN_STEPS`: How many training steps to run. (choose more than 10 for this example)
*   `PROFILE_DURATION`: Length of the profiling time (unit ms).
*   `RESOLUTION`: Image resolution.
