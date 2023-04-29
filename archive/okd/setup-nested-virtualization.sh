#!/bin/bash

AMD_VENDOR_ID="AuthenticAMD"
INTEL_VENDOR_ID="GenuineIntel"
CURRENT_VENDOR_ID=$(lscpu | grep -oiP '(?<=Vendor.ID:).+?(?=$)' | xargs)
NV_SUPPORT=""
KVM_KMOD=""

if [[ ${CURRENT_VENDOR_ID} == ${INTEL_VENDOR_ID} ]]; then
    NV_SUPPORT=$(cat /sys/module/kvm_intel/parameters/nested)
    KVM_KMOD="kvm_intel"
elif [[ ${CURRENT_VENDOR_ID} == ${AMD_VENDOR_ID} ]]; then
    NV_SUPPORT=$(cat /sys/module/kvm_amd/parameters/nested)
    KVM_KMOD="kvm_amd"
else
    echo "CPU \"${CURRENT_VENDOR_ID}\" not supported!"
    exit 1
fi

if [[ ${NV_SUPPORT} == "0" || ${NV_SUPPORT} == "N" ]]; then
    echo "Nested virtualization not supported! Vendor: \"${CURRENT_VENDOR_ID}\" Support: \"${NV_SUPPORT}\""
    exit 2
fi

echo "Nested virtualization supported! Vendor: \"${CURRENT_VENDOR_ID}\" Support: \"${NV_SUPPORT}\""
echo "Enabling nested virtualization..."
sudo modprobe -r ${KVM_KMOD}
sudo modprobe ${KVM_KMOD} nested=1
sudo sed -i 's|^#options '${KVM_KMOD}' nested=1$|options '${KVM_KMOD}' nested=1|' /etc/modprobe.d/kvm.conf
