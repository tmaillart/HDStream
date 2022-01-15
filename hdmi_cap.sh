#!/bin/sh

export GST_DEBUG=*:3

gst-launch-1.0 \
	v4l2src \
		device=/dev/video2 \
	! image/jpeg,width=1280,height=720,framerate=30/1 \
	! jpegdec \
	! x264enc \
		tune=zerolatency \
	! queue \
	! mpegtsmux \
		name=mux \
	! hlssink \
		max-files=5 \
	alsasrc \
		device=hw:1,0 \
	! audio/x-raw,format=S16LE,channels=2,rate=48000 \
	! lamemp3enc \
	! mpegaudioparse \
	! queue \
	! mux.

exit
	! xvimagesink \
	\
	pulsesrc \
		device=alsa_input.usb-MACROSILICON_USB_Video-02.iec958-stereo \
	! pulsesink
