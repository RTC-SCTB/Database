#!/bin/sh
#run CAN bus
sudo ip link set can0 up type can bitrate 500000
#starting demon can2net
/home/pi/can/can2net /home/pi/can/libcan_handler.so &
# video
/home/pi/gstreamer/sendvideo.sh &