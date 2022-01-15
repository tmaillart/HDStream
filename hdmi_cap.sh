#!/bin/sh

export GST_DEBUG=*:3,v4l2src:1

trap 'killall busybox' EXIT

rm *.ts
# add -f for foreground
busybox httpd -p 0.0.0.0:8080
gst-launch-1.0 \
	v4l2src \
		device=/dev/video0 \
	! image/jpeg,width=1280,height=720,framerate=30/1 \
	! jpegdec \
	! videoscale \
		method=0 \
	! video/x-raw,width=720,height=480 \
	! x264enc \
		tune=zerolatency \
		speed-preset=3 \
	! queue \
	! mpegtsmux \
		name=mux \
	! hlssink \
		max-files=3 \
	alsasrc \
		device=hw:2,0 \
	! audio/x-raw,format=S16LE,channels=2,rate=48000 \
	! audioconvert \
	! audioresample \
		resample-method=1 \
	! audio/x-raw,format=S16LE,channels=1,rate=44100 \
	! lamemp3enc bitrate=128 \
	! mpegaudioparse \
	! queue \
	! mux.

exit
	! xvimagesink \
	\
	pulsesrc \
		device=alsa_input.usb-MACROSILICON_USB_Video-02.iec958-stereo \
	! pulsesink
