#!/bin/bash

NAME="S99custom"

autoboot_switch_to()
{
    mkdir -p /tmp/recalplex/settings
    mkdir -p /tmp/recalplex/recovery
    mount /dev/mmcblk0p5 /tmp/recalplex/settings
    mount /dev/mmcblk0p1 /tmp/recalplex/recovery
    cp /tmp/recalplex/settings/autoboot_$1.txt /tmp/recalplex/recovery/autoboot.txt
}

# Carry out specific functions when asked to by the system
case "$1" in
    start)
        recallog "Starting $NAME"
    ;;
    stop)
        recallog "Stopping $NAME"
        if [ -e "/tmp/reboot.please" ]; then
            if [ -e "/recalbox/share/system/upgrade/boot.tar.xz" ] &&
                [ -e "/recalbox/share/system/upgrade/root.tar.xz" ]; then
                recallog "Reboot for update"
            else
                recallog "Reboot on Rasplex partition"
                autoboot_switch_to rasplex
            fi
        fi
    ;;
    *)
        echo "Usage: /etc/init.d/S99custom {start | stop}"
        exit 1
    ;;
esac

exit 0
