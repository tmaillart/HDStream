# HDStream

depends on https://github.com/tmaillart/gst-rtsp-server

## Prerequisite
To get the `gst-rtsp-launch` binary use in the scripts
From the repo above:
```
gcc $(pkg-config --cflags --libs gstreamer-1.0) $(pkg-config --cflags --libs gstreamer-rtsp-server-1.0) test-launch.c -o gst-rtsp-launch */
```
