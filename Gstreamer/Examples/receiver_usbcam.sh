#!/bin/sh

DEST=192.168.42.230

RTPBIN_PARAMS="buffer-mode=0 do-retransmission=false drop-on-latency=true latency=250"
VIDEO_CAPS="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)JPEG"
VIDEO_DEC="rtpjpegdepay ! jpegdec"
VIDEO_SINK="autovideosink"

gst-launch-1.0 -v \
    rtpbin name=rtpbin $RTPBIN_PARAMS \
	udpsrc caps=$VIDEO_CAPS port=5000 ! rtpbin.recv_rtp_sink_0 \
        rtpbin. ! $VIDEO_DEC ! $VIDEO_SINK \
	udpsrc port=5001 ! rtpbin.recv_rtcp_sink_0 \
	rtpbin.send_rtcp_src_0 ! udpsink port=5005 host=$DEST sync=false async=false