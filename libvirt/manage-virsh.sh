#!/bin/bash

set -e

BACKUP_TMP_DIR="/tmp/virsh_backups/"
DEFAULT_LIBVIRT_IMAGES_DIR="/var/lib/libvirt/images/"
DEFAULT_LIBVIRT_IMAGES_EXT=".qcow2"

function usage(){
    echo \
"Usage: 
    $0 [-h|--help] SUB_COMMAND [SUB_COMMAND_OPTS]
    
    -h|--help           Displays this menu
    SUB_COMMAND         The subcommand to run. See -h on the subcommand to see what it does.
    SUB_COMMAND_OPTS    The options of the subcommand. See -h on the subcommand to see its options.

    SUB_COMMANDS:
        - backup        Backs up one or more VMs from a VM_NAME arg list
        - delete        Deletes one or more VMs from a VM_NAME arg list
        - list          List all running system-level VMs
        - restore       Restores one or more VMs from a TAR_FNAME arg list
                        
    Example:
        1: $0 backup -h
        2: $0 delete -h
        3: $0 restore -h
        
    Note: 
    This tool assumes:
        - Only one disk per VM
        - Expects this disk in the default libvirt images dir
        - Expects the disk to be named VM_NAME+.qcow2
        - Expects the disk to be a qcow2 with the .qcow2 extension.
    If you do not meet these assumptions, then please use caution when using this tool."
}

function usage_delete(){
    echo \
"Usage: 
    $0 delete [-h|--help] [-f|--no-confirm] VM_NAMES...
    
    -h|--help           Displays this menu
    -f|--no-confirm     Do not prompt y/n on before delete. Just assume 'y'.
    VM_NAMES            A VM you want to delete.
                        
    Example:
        $0 delete -f VM1 VM2"
}


function usage_backup(){
    echo \
"Usage: 
    $0 backup [-h|--help] [-r|--remove] VM_NAMES...
    
    -h|--help           Displays this menu
    -r|--remove         After the VM is successfully backed up, remove its virtual disk and def from FS.
    VM_NAMES            A VM you want to backup.
                        
    Example:
        $0 backup -r VM1 VM2"
}

function usage_restore(){
    echo \
"Usage: 
    $0 restore [-h|--help] TAR_FNAMES...
    
    -h|--help           Displays this menu
    TAR_FNAMES          Tars to restore.
                        
    Example:
        $0 restore ./VM1-backup-20200521110315.tar.gz ./VM2-backup-20200521110425.tar.gz"
}

function list(){
    echo "Available VMs:"
    sudo virsh list --all
    echo
}

function delete(){
    ############################ Handle args ############################
    local positional=()
    local do_confirm=1
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -f|--no-confirm)
                do_confirm=0
                shift
            ;;
            -h|--help)
                usage_delete
                exit 0
            ;;
            -*|--*)
                echo "Error: Unsupported flag \"$1\""
                echo
                usage_delete
                exit 1
            ;;
            *)
                positional+=("$1")
                shift
            ;;
        esac
    done
    #restore positional args to call as $1,$2,$3...
    set -- "${positional[@]}"
    if [[ $# -eq 0 ]]; then
        echo "One or more VM_NAME(S) is required!"
        usage_delete
        exit 2
    fi
    #####################################################################
    for vm_name in "$@"; do
        local vm_disk="${DEFAULT_LIBVIRT_IMAGES_DIR}${vm_name}${DEFAULT_LIBVIRT_IMAGES_EXT}"
        local process_delete=0
        if [[ do_confirm -eq 1 ]]; then
            while true; do
                read -p "Are you sure you want to delete ${vm_name} and its disk: ${vm_disk}?" yn
                case $yn in
                    [Yy]*)
                        process_delete=1
                        break
                        ;;
                    [Nn]*)
                        process_delete=0
                        break
                        ;;
                    *)
                        echo "Please answer yes or no."
                        ;;
                esac
            done
        else
            process_delete=1
        fi
        if [[ process_delete -eq 1 ]]; then
            sudo virsh undefine ${vm_name}
            sudo rm -v ${vm_disk}
        fi
    done
}

function backup(){
    local backup_save_dir="./"
    ############################ Handle args ############################
    local positional=()
    local remove_vm_after=0
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -r|--remove)
                remove_vm_after=1
                shift
            ;;
            -h|--help)
                usage_backup
                exit 0
            ;;
            -*|--*)
                echo "Error: Unsupported flag \"$1\""
                echo
                usage_backup
                exit 1
            ;;
            *)
                positional+=("$1")
                shift
            ;;
        esac
    done
    set -- "${positional[@]}"
    if [[ $# -eq 0 ]]; then
        echo "One or more VM_NAME(S) is required!"
        usage_backup
        exit 2
    fi
    #####################################################################
    mkdir -vp ${BACKUP_TMP_DIR}

    for vm_name in "$@"; do
        local vm_xml="${BACKUP_TMP_DIR}${vm_name}.xml"
        local vm_disk="${DEFAULT_LIBVIRT_IMAGES_DIR}${vm_name}${DEFAULT_LIBVIRT_IMAGES_EXT}"
        local output_tar="${backup_save_dir}${vm_name}-backup-$(date +"%Y%m%d%H%M%S").tar.gz"
        sudo virsh dumpxml ${vm_name} > ${vm_xml}
        sudo tar -czvf ${output_tar} -C / ${vm_xml} ${vm_disk}
        sudo chown ${USER}:${USER} ${output_tar}
        echo "Saved: ${output_tar}"
        if [[ remove_vm_after -eq 1 ]]; then
            delete --no-confirm ${vm_name}
        fi
    done
}

function restore(){
    ############################ Handle args ############################
    local positional=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage_restore
                exit 0
            ;;
            -*|--*)
                echo "Error: Unsupported flag \"$1\""
                echo
                usage_restore
                exit 1
            ;;
            *)
                positional+=("$1")
                shift
            ;;
        esac
    done
    set -- "${positional[@]}"
    if [[ $# -eq 0 ]]; then
        echo "One or more TAR_FNAME(S) is required!"
        usage_restore
        exit 2
    fi
    #####################################################################
    for tar_fname in "$@"; do
        local vm_name="$(basename ${tar_fname} | rev | cut -d '-' -f 3- | rev)"
        local vm_xml="${BACKUP_TMP_DIR}${vm_name}.xml"
        sudo tar -xzvf ${tar_fname} -C /
        sudo virsh define ${vm_xml}
    done
}

if [[ $# -eq 0 ]]; then
    echo "One or more subcommand is required!"
    usage
    exit 2
fi
if [[ $1 == "-h" || $1 == "--help" ]]; then
    usage
    exit 0
fi
$1 "${@:2}"
