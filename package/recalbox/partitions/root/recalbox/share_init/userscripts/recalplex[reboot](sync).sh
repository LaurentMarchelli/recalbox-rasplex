#!/bin/sh
switch_to=rasplex
mkdir -p /tmp/recalplex/settings
mkdir -p /tmp/recalplex/recovery
mount /dev/mmcblk0p5 /tmp/recalplex/settings
mount /dev/mmcblk0p1 /tmp/recalplex/recovery
cp /tmp/recalplex/settings/autoboot_${switch_to}.txt /tmp/recalplex/recovery/autoboot.txt
