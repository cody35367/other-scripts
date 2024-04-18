#!/bin/bash

rm -fv sender receiver

gcc sender.c -o sender
gcc receiver.c -o receiver
