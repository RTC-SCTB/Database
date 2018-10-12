#!/bin/sh

DEST=192.168.42.230

RTPBIN_PARAMS="buffer-mode=0 do-retransmition=false drop-on-latency=true latency=250"
VIDEO_CAPS_MAIN="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=96"
VIDEO_DEC_MAIN="rtph264depay ! avdec_h264 ! videorate"
VIDEO_SINK_MAIN="glupload ! glcolorconvert ! gloverlay location=rovergrid.png ! glimagesink sync=false"

VIDEO_CAPS_LINE="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)JPEG,payload=26"
VIDEO_DEC_LINE="rtpjpegdepay ! jpegdec"
VIDEO_SINK_LINE="autovideosink sync=false"

gst-launch-1.0 -v --gst-debug-level=0  \
    rtpbin name=rtpbin $RTPBIN_PARAMS \
	udpsrc caps=$VIDEO_CAPS_MAIN port=6000 ! rtpbin.recv_rtp_sink_0 \
        rtpbin. ! $VIDEO_DEC_MAIN ! $VIDEO_SINK_MAIN \
	udpsrc port=6001 ! rtpbin.recv_rtcp_sink_0 \
	rtpbin.send_rtcp_src_0 ! udpsink port=6005 host=$DEST sync=false async=false \
        udpsrc caps=$VIDEO_CAPS_LINE port=5000 ! rtpbin.recv_rtp_sink_1 \
        rtpbin. ! $VIDEO_DEC_LINE ! $VIDEO_SINK_LINE \
        udpsrc port=5001 ! rtpbin.recv_rtcp_sink_1 \
        rtpbin.send_rtcp_src_1 ! udpsink port=5005 host=$DEST sync=false async=false