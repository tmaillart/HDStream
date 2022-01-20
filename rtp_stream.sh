#!/bin/sh

export GST_DEBUG=*:3,v4l2src:1

gst-rtsp-launch "( \
        mpegtsmux \
		name=mux \
	! rtpmp2tpay \
		name=pay0 \
        v4l2src \
	! videoconvert \
	! x264enc \
	! queue \
	! mux. \
        audiotestsrc \
	! lamemp3enc \
	! mpegaudioparse \
	! queue \
	! mux. )"

