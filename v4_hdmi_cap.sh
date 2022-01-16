#!/bin/sh

export GST_DEBUG=*:3,v4l2src:1,omxvideo:3

trap 'killall busybox' EXIT

rm *.ts playlist.* 2>/dev/null

# add -f for foreground
busybox httpd -p 0.0.0.0:8080

gst-launch-1.0 \
	v4l2src \
		device=/dev/video0 \
	! image/jpeg,width=1280,height=720,framerate=30/1 \
	! jpegdec \
	! videoconvert \
	! v4l2h264enc \
	! 'video/x-h264,profile=constrained-baseline,level=(string)4' \
	! h264parse \
	! queue \
	! mpegtsmux \
		name=mux \
	! hlssink \
		max-files=5 \
	alsasrc \
		device=hw:2,0 \
	! audio/x-raw,format=S16LE,channels=2,rate=48000 \
	! audioconvert \
	! audio/x-raw,channels=1 \
	! lamemp3enc \
		bitrate=128 \
	! mpegaudioparse \
	! queue \
	! mux.
