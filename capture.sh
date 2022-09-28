#!/bin/sh

VIDEO_DEV=/dev/video0
AUDIO_DEV=alsa_input.usb-MACROSILICON_USB_Video-02.iec958-stereo

GST_DEBUG=*:3 gst-launch-1.0 -e -v \
	v4l2src \
		"device=$VIDEO_DEV" \
	! image/jpeg,width=1280,height=720,framerate=20/1 \
	! jpegdec \
	! videoconvert \
	! tee \
		name=t \
	! queue \
	! videoconvert \
	! x265enc \
		tune=zerolatency \
	! video/x-h265 \
	! h265parse \
	! matroskamux \
		name=mux \
	! filesink \
		location=revo.mkv \
	t. \
	! waylandsink \
	pulsesrc \
		"device=$AUDIO_DEV" \
	! lamemp3enc \
	! mpegaudioparse \
	! queue \
	! mux.
