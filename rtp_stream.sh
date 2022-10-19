#!/bin/sh

export GST_DEBUG=*:3,v4l2src:1

#V4L2_DEV='/dev/video0'
#ALSA_DEV='hw:4,0'
if [ -z "$ALSA_DEV" ] || ! [ -e "/dev/snd/$(echo "$ALSA_DEV" | sed 's/hw:/pcmC/ ; s/,/D/')c" ] ;then
	cat /proc/asound/cards
	printf '\nselect: '
	read ALSA_DEV
fi

if [ -z "$V4L2_DEV" ];then
	ls -1 /dev/video*
	read V4L2_DEV
fi

gst-rtsp-launch -a 0.0.0.0 "( \
	v4l2src \
		device=$V4L2_DEV \
	! image/jpeg,width=1280,height=720,framerate=60/1 \
	! jpegdec \
	! videoconvert \
	! x265enc \
		tune=zerolatency \
	! capsfilter caps=video/x-h265 \
	! h265parse \
	! rtph265pay \
		name=pay0 \
        alsasrc \
		device=$ALSA_DEV \
		provide-clock=false \
		use-driver-timestamps=true \
	! audio/x-raw,format=S16LE,rate=48000,channels=2 \
	! lamemp3enc \
	! mpegaudioparse \
	! rtpmpapay \
		name=pay1 )"

