#!/bin/bash
#
# Sets attributes for xfce4 config

# Set i3-fancy-rapid as default screen lock command
xfconf-query -c xfce4-session -p /general/LockCommand -s "i3lock-fancy-rapid 5 5"
