echo ZoomBlock camera 25.000 FPS version at /dev/video0 with 1920 x 1080 x 25/1, format=BGRA

gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw, format=BGRA, width=1920, height=1080, framerate=25/1 ! videoconvert ! autovideosink
