#!/bin/bash
set -ex

# Parameters
VERSION=$1

case ${VERSION} in
    10) NVIDIA_VERSION="535.86.10"; 
        CUDA_VERSION="12-2"; 
        CUDA_SAMPLES_VERSION="12.2";
        CHECKSUM="cec37fd9317091a01fd0380309400a14284769790651fe021e1d5aaa2327a370";;
    11) NVIDIA_VERSION="535.86.10"; 
        CUDA_VERSION="12-2"; 
        CUDA_SAMPLES_VERSION="12.2";
        CHECKSUM="cec37fd9317091a01fd0380309400a14284769790651fe021e1d5aaa2327a370";;
    12) NVIDIA_VERSION="535.86.10"; 
        CUDA_VERSION="12-2"; 
        CUDA_SAMPLES_VERSION="12.2";
        CHECKSUM="cec37fd9317091a01fd0380309400a14284769790651fe021e1d5aaa2327a370";;
    *) ;;
esac

# Reference - https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu-installation
# Install Cuda
wget https://developer.download.nvidia.com/compute/cuda/repos/debian${VERSION}/x86_64/cuda-keyring_1.0-1_all.deb
dpkg -i ./cuda-keyring_1.0-1_all.deb

apt-get update
apt install -y cuda-toolkit-${CUDA_VERSION}
echo 'export PATH=$PATH:/usr/local/cuda/bin' | tee -a /etc/bash.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64' | tee -a /etc/bash.bashrc
$COMMON_DIR/write_component_version.sh "CUDA" ${CUDA_VERSION}

# Download CUDA samples
TARBALL="v${CUDA_SAMPLES_VERSION}.tar.gz"
CUDA_SAMPLES_DOWNLOAD_URL=https://github.com/NVIDIA/cuda-samples/archive/refs/tags/${TARBALL}
wget ${CUDA_SAMPLES_DOWNLOAD_URL}
tar -xvf ${TARBALL}
pushd ./cuda-samples-${CUDA_SAMPLES_VERSION}
make
mv -vT ./Samples /usr/local/cuda-${CUDA_SAMPLES_VERSION}/samples
popd

# Nvidia driver
NVIDIA_DRIVER_URL=https://us.download.nvidia.com/tesla/${NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run
$COMMON_DIR/download_and_verify.sh $NVIDIA_DRIVER_URL ${CHECKSUM}
bash NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run --silent --dkms
$COMMON_DIR/write_component_version.sh "NVIDIA" ${NVIDIA_VERSION}