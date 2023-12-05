#!/bin/bash
set -ex

# Parameter
# Debian Version
VERSION=$1

# Install nvidia fabric manager
case ${VERSION} in
    10) NVIDIA_FABRIC_MANAGER_VERSION="535_535.86.10-1"; 
        CHECKSUM="d0c4662279301187614646650da07f34a6fe267d789d48bc9ed63181af06ac29";
        VERSION_PREFIX="535";;
    11) NVIDIA_FABRIC_MANAGER_VERSION="535_535.86.10-1"; 
        CHECKSUM="d0c4662279301187614646650da07f34a6fe267d789d48bc9ed63181af06ac29";
        VERSION_PREFIX="535";;
    12) NVIDIA_FABRIC_MANAGER_VERSION="535_535.86.10-1"; 
        CHECKSUM="d0c4662279301187614646650da07f34a6fe267d789d48bc9ed63181af06ac29";
        VERSION_PREFIX="535";;
    *) ;;
esac

NVIDIA_FABRIC_MNGR_URL=http://developer.download.nvidia.com/compute/cuda/repos/debian${VERSION}/x86_64/nvidia-fabricmanager-${NVIDIA_FABRIC_MANAGER_VERSION}_amd64.deb
$COMMON_DIR/download_and_verify.sh $NVIDIA_FABRIC_MNGR_URL ${CHECKSUM}
apt install -y ./nvidia-fabricmanager-${NVIDIA_FABRIC_MANAGER_VERSION}_amd64.deb
apt-mark hold nvidia-fabricmanager-${VERSION_PREFIX}
$COMMON_DIR/write_component_version.sh "NVIDIA_FABRIC_MANAGER" ${NVIDIA_FABRIC_MANAGER_VERSION}
