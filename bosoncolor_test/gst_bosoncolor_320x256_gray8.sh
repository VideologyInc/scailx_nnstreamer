echo Boson+ camera at /dev/video1 with 320 x 256 x 60/1, format=GRAY8

gst-launch-1.0 v4l2src device=/dev/video1 ! video/x-raw, format=GRAY8, width=320, height=256, framerate=60/1 ! videoconvert ! autovideosink
