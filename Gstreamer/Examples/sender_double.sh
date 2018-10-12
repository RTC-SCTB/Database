#!/bin/sh

DEST=192.168.42.100

VELEM_LINE="v4l2src device=/dev/video0"
VOFFSET=0
AOFFSET=0

VCAPS_LINE="video/x-raw, width=(int)160, height=(int)120, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)30/1, encoding-name=(string)JPEG"

VENC_LINE="jpegenc ! rtpjpegpay"

VRTPSINK_LINE="udpsink port=5000 host=$DEST sync=false async=false name=vrtpsink_l"
VRTCPSINK_LINE="udpsink port=5001 host=$DEST sync=false async=false name=vrtcpsink_l"
VRTCPSRC_LINE="udpsrc port=5005 name=vrtcpsrc_l"

VELEM_MAIN="fdsrc"
VENC_MAIN="h264parse ! rtph264pay config-interval=10 pt=96"

VRTPSINK_MAIN="udpsink port=6000 host=$DEST ts-offset=$VOFFSET name=vrtpsink"
VRTCPSINK_MAIN="udpsink port=6001 host=$DEST sync=false async=false name=vrtcpsink"
VRTCPSRC_MAIN="udpsrc port=6005 name=vrtpsrc"

RTPBIN_PARAMS=""

raspivid -n -e -w 960 -h 540 -b 10000000 -fps 30 -vf -hf -t 0 -o - | \
gst-launch-1.0 -v --gst-debug-level=3 rtpbin ntp-sync=false name=rtpbin \
    $VELEM_MAIN ! $VENC_MAIN ! queue ! rtpbin.send_rtp_sink_0 \
        rtpbin.send_rtp_src_0 ! $VRTPSINK_MAIN \
        rtpbin.send_rtcp_src_0 ! $VRTCPSINK_MAIN \
    $VRTCPSRC_MAIN ! rtpbin.recv_rtcp_sink_0 \
    $VELEM_LINE ! $VCAPS_LINE ! $VENC_LINE ! rtpbin.send_rtp_sink_1 \
        rtpbin.send_rtp_src_1 ! $VRTPSINK_LINE \
        rtpbin.send_rtcp_src_1 ! $VRTCPSINK_LINE \
    $VRTCPSRC_LINE ! rtpbin.recv_rtcp_sink_1