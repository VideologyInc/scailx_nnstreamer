#!/usr/bin/env bash

gst-launch-1.0 \
  v4l2src device=/dev/video1 ! video/x-raw,format=GRAY16_LE,width=320,height=256,framerate=60/1 ! \
  videorate max-rate=10 ! video/x-raw,framerate=10/1 ! \
  queue leaky=2 max-size-buffers=10 ! \
  videoconvert ! video/x-raw, format=GRAY8 ! \
  tensor_converter ! \
  tensor_transform mode=arithmetic option=typecast:float32,add:-20.0,mul:30.0 ! \
  queue leaky=2 max-size-buffers=10 ! \
  tensor_transform mode=clamp option=0.0:255.0 ! \
  tensor_transform mode=typecast option=uint8 ! \
  queue leaky=2 max-size-buffers=10 ! \
  tensor_decoder mode=direct_video ! videoconvert ! autovideosink sync=false
