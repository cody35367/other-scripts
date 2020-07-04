#!/bin/bash

ssh-copy-id $1
ssh -t $1 "sudo bash -c 'echo %wheel ALL=\(ALL\) NOPASSWD: ALL > /etc/sudoers.d/passwordless'"
