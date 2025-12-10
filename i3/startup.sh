#!/bin/sh
# Give X a moment to create the devices
sleep 3

DEVICE="Logitech USB Receiver Mouse"

# Enable natural scrolling
xinput set-prop "$DEVICE" "libinput Natural Scrolling Enabled" 1

# Set pointer sensitivity (-1.0 = slowest, 1.0 = fastest)
xinput set-prop "$DEVICE" "libinput Accel Speed" 0.5
