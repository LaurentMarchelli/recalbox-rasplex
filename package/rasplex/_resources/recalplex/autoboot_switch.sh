#!/bin/bash
mkdir -p /tmp/recalplex
mount /dev/mmcblk0p1 /tmp/recalplex
cp /tmp/recalplex/autoboot_$1.txt /tmp/recalplex/autoboot.txt
reboot
