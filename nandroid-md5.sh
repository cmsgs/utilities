#!/bin/sh
cd $1

adb reboot recovery

sleep 15

adb push system.img /tmp/

md5sum system.img > nandroid.md5

adb push nandroid.md5 /tmp/

adb shell rm -rf /system/

adb shell nandroid restore /tmp/

adb reboot

return $?
