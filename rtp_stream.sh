#!/bin/sh

export GST_DEBUG=*:3,v4l2src:1

#V4L2_DEV='/dev/video0'
#PULSE_DEV='alsa_input.usb-MACROSILICON_USB3._0_capture-02.iec958-stereo'
if [ -z "$PULSE_DEV" ] || ! pactl get-source-volume "$PULSE_DEV" >/dev/null 2>/dev/null;then
	pactl list short sources
	printf '\nselect: '
	read PULSE_DEV
fi

if [ -z "$V4L2_DEV" ];then
	ls -1 /dev/video*
	read V4L2_DEV
fi

gst-rtsp-launch -a 0.0.0.0 "( \
        mpegtsmux \
		name=mux \
	! rtpmp2tpay \
		name=pay0 \
	v4l2src \
		device=$V4L2_DEV \
	! image/jpeg,width=1280,height=720,framerate=60/1 \
	! jpegdec \
	! videoconvert \
	! x265enc \
		tune=zerolatency \
	! capsfilter caps=video/x-h265 \
	! h265parse \
	! queue \
	! mux. \
        pulsesrc \
		device=$PULSE_DEV \
	! lamemp3enc \
	! mpegaudioparse \
	! queue \
	! mux. )"

