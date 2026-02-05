echo Boson+ camera at /dev/video1 with 320 x 256 x 60/1, format=GRAY16_LE plus videobalance to increase contrast

gst-launch-1.0 v4l2src device=/dev/video1 ! video/x-raw, format=GRAY16_LE, width=320, height=256, framerate=60/1 ! videoconvert ! video/x-raw, format=RGB ! videobalance contrast=2.0 brightness=0.1 ! videoconvert ! autovideosink
