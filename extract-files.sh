#!/bin/bash
#
# Copyright (C) 2018-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so)
            "${PATCHELF_0_8}" --remove-needed "libprotobuf-cpp-lite.so" "${2}"
            ;;
	vendor/lib/libmmcamera2_sensor_modules.so)
	    sed -i 's|/system/etc/camera/|/vendor/etc/camera/|g' "${2}"
	    ;;
        vendor/lib64/libgf_ca.so)
            "${PATCHELF_0_8}" --add-needed "fakelogprint.so" "${2}"
            ;;
        vendor/lib64/libgf_hal.so)
            "${PATCHELF_0_8}" --add-needed "fakelogprint.so" "${2}"
            ;;
        vendor/lib64/hw/gf_fingerprint.goodix.default.so)
            "${PATCHELF_0_8}" --add-needed "fakelogprint.so" "${2}"
            ;;
    esac
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

# Required!
export DEVICE=tissot
export DEVICE_COMMON=msm8953-common
export VENDOR=xiaomi

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
