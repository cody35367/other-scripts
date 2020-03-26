#!/bin/bash

function usage(){
    echo \
"Usage: 
    1: $0 [-s|--stop-on-error] [-u|--user] ip_addresses script_file [-- pass_thru_arg1 ...]
    2: $0 [-s|--stop-on-error] [-u|--user] ip_addresses [-c|--command cmd]
    3: $0 [-h|--help]
    
    -s|--stop-on-error  Stop executing if any part of the script returns a non-zero code between
                        hosts.
    -u|--user           This is the SSH user to be used for every IP in the comma separated list.
                        This is a quick way of specifying the same user for all IPs. Alternatively,
                        you can add user@ in front of each IP in the comma separated list but do
                        not this flag in that case.
    -h|--help           Display this menu.
    ip_addresses        A comma separated list of IPs to run the script on. Can also be hostnames.
    -c|--command cmd    Instead of sending a script file, sent a command over the default ssh shell
                        to the remote host. This will cause any reference to a script file to be
                        ignored and will also ignore the -- option. The cmd should be sent as
                        one string with quotes keeping it as one parameter.
    script_file         The local script file to run on the remote hosts.
    --                  Anything after this marker will be passed through to the script file
                        when it runs on the remote hosts
                        
    Example:
        1: $0 -s -u user 10.0.0.2,10.0.0.3,10.0.0.4 ./script.sh -- -a --arg2
        2: $0 -s user@10.0.0.2,user1@10.0.0.3,user5@10.0.0.4 \"ls -la\"
        3: $0 --help"
}

############################ Handle args ############################
STOP_ON_ERROR="false"
POSITIONAL=()
PASS_THRU_ARGS=()
REMOTE_COMMAND=""
LOCAL_SCRIPT=""
SSH_USERS=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--stop-on-error)
        STOP_ON_ERROR="true"
        shift
        ;;
        -u|--user)
        SSH_USERS="$2"
        shift
        shift
        ;;
        -h|--help)
        usage
        exit 0
        shift
        ;;
        -c|--command)
        REMOTE_COMMAND="$2"
        shift
        shift
        ;;
        --)
        # pass over the --
        shift
        while [[ $# -gt 0 ]]; do
            PASS_THRU_ARGS+=("$1")
            shift
        done
        ;;
        -*|--*)
        echo "Error: Unsupported flag \"$1\""
        echo
        usage
        exit 1
        ;;
        *)
        POSITIONAL+=("$1")
        shift
        ;;
    esac
done
#restore positional args to call as $1,$2,$3...
set -- "${POSITIONAL[@]}"
# Get the IPs from the first positional parm and replace all ','s
# with ' ' to allow use of the 'in' keyword.
SSH_IPS=${1//,/ }
if [[ ${STOP_ON_ERROR} == "true" ]]; then
    set -e
fi
if [[ -z ${REMOTE_COMMAND} ]]; then
    if [[ $# -ne 2 ]]; then
        echo "Script File usage: Expecting 2 positional arguments but got $#"
        usage
        exit 2
    fi
    LOCAL_SCRIPT=${2}
    if [[ ! -f ${LOCAL_SCRIPT} ]]; then
        echo "Could not find script file \"${LOCAL_SCRIPT}\""
        exit 3
    fi
else
    if [[ $# -ne 1 ]]; then
        echo "Command usage: Expecting 1 positional arguments but got $#"
        usage
        exit 4
    fi
fi
#####################################################################

############################## Run SSH ##############################
for ip in ${SSH_IPS}; do
    if [[ -n ${SSH_USERS} ]]; then
        ip="${SSH_USERS}@${ip}"
    fi
    if [[ -z ${REMOTE_COMMAND} ]]; then
        echo "Running \"${LOCAL_SCRIPT} ${PASS_THRU_ARGS[@]}\" on ${ip}:"
        ssh < "${LOCAL_SCRIPT}" ${ip} "bash -s -- ${PASS_THRU_ARGS[@]}"
    else
        echo "Running \"${REMOTE_COMMAND}\" on ${ip}:"
        ssh ${ip} "${REMOTE_COMMAND}"
    fi
done
#####################################################################