#!/bin/bash
worker_id=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/agent-worker-number" -H 'Metadata-Flavor: Google')

cat >> /dev/null <<EOF
EOF

stdbuf -oL bash <<-PIPE_EOF 2>&1 | sed "s/^/[worker $slice_id:$worker_id] /g" | tee runlog
  set -o xtrace
  # Configure docker
  sudo groupadd docker
  sudo usermod -aG docker $USER
  # newgrp applies updated group permissions
  newgrp - docker
  gcloud auth configure-docker us-central1-docker.pkg.dev --quiet
  # Kill any running benchmarks
  docker kill $USER-test
  docker pull us-central1-docker.pkg.dev/tpu-pytorch/docker/development/pytorch-tpu-diffusers:v1
  docker run --rm \
    --name $USER-test \
    --privileged \
    --env-file env.sh \
    -v /home/$USER:/tmp/home \
    --shm-size=16G \
    --net host \
    -u root \
    --entrypoint /bin/bash us-central1-docker.pkg.dev/tpu-pytorch/docker/development/pytorch-tpu-diffusers:v1 \
    /tmp/home/train.sh

PIPE_EOF
