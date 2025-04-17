#!/bin/bash
set -ex

source ${COMMON_DIR}/utilities.sh

ofed_metadata=$(get_component_config "ofed")
OFED_VERSION=$(jq -r '.version' <<< $ofed_metadata)
OFED_SHA256=$(jq -r '.sha256' <<< $ofed_metadata)
OFED_URL=$(jq -r '.url' <<< $ofed_metadata)
OFED_FILE=$(basename ${OFED_URL})

$COMMON_DIR/download_and_verify.sh $OFED_URL $OFED_SHA256

tar zxvf ${OFED_FILE}
OFED_FOLDER=$(basename ${OFED_FILE} .tgz)

./${OFED_FOLDER}/mlnxofedinstall --add-kernel-support --skip-unsupported-devices-check --without-fw-update --with-nvmf
$COMMON_DIR/write_component_version.sh "OFED" $OFED_VERSION

/etc/init.d/openibd restart
/etc/init.d/openibd status
error_code=$?
if [ ${error_code} -ne 0 ]
then
    echo "OpenIBD not loaded correctly!"
    exit ${error_code}
fi
