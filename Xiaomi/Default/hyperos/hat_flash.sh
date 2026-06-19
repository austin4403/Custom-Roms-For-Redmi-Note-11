#!/bin/bash

flash_log="flash_$1.log"
rm -f  $flash_log > /dev/null 2>&1
ANDROID_SERIAL=$1

adb reboot bootloader > /dev/null 2>&1

function fastboot_dev_found() {
    fastboot -s $1 devices | grep $1
    return $?
}

function check_flash_result() {
    grep "failed" $flash_log -i
    if [ $? -eq 0 ];then
        echo "Flash image error, exit!"
        exit -1
    fi
}

echo "Now waiting device $1 enter to fastboot mode!"
declare -i ret=1
until ((ret==0))
do
    fastboot_dev_found $1
    ret=$?
    sleep 2
done
echo "Device $1 found by fastboot"

./flash_all.sh

fastboot -s $1 reboot
