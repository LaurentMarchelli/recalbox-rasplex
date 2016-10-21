#!/bin/bash

autoboot_switch_to()
{
    mkdir -p /tmp/recalplex/settings
    mkdir -p /tmp/recalplex/recovery
    mount /dev/mmcblk0p5 /tmp/recalplex/settings
    mount /dev/mmcblk0p1 /tmp/recalplex/recovery
    cp /tmp/recalplex/settings/autoboot_$1.txt /tmp/recalplex/recovery/autoboot.txt
}

autoboot_switch_to $1
reboot
