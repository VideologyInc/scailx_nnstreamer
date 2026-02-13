#!/usr/bin/env bash

gst-launch-1.0 \
  v4l2src device=/dev/video1 ! video/x-raw,format=GRAY16_LE,width=640,height=512,framerate=60/1 ! \
  videorate max-rate=10 ! video/x-raw,framerate=10/1 ! \
  queue leaky=2 max-size-buffers=10 ! \
  videoscale ! video/x-raw, width=640, height=504 ! \
  tensor_converter ! \
  tensor_transform mode=arithmetic option=typecast:float32,add:-5000.0,div:8.0 ! \
  queue leaky=2 max-size-buffers=10 ! \
  tensor_transform mode=clamp option=0.0:255.0 ! \
  tensor_transform mode=typecast option=uint8 ! \
  queue leaky=2 max-size-buffers=10 ! \
  tensor_decoder mode=direct_video ! videoconvert ! autovideosink sync=false
