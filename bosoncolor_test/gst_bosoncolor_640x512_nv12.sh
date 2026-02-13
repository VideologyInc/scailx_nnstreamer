echo Boson+ camera at /dev/video1 with 640 x 512 x 60/1, format=NV12

gst-launch-1.0 v4l2src device=/dev/video1 ! video/x-raw, format=NV12, width=640, height=512, framerate=60/1 ! videoconvert ! autovideosink
