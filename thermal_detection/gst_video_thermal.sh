gst-launch-1.0 \
  filesrc location=video_flir_1.mp4 ! \
  qtdemux ! h264parse ! avdec_h264 ! \
  tee name=t \
  t. ! queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
  videoconvert ! videoscale ! video/x-raw,format=RGB,width=320,height=320 ! \
  tensor_converter ! \
  tensor_transform mode=arithmetic option=typecast:float32,add:0.0,div:255.0 ! \
  queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
  tensor_filter latency=1 framework=tensorflow2-lite model=thermal_f16.tflite ! \
  tensor_transform mode=transpose option=1:0:2:3 ! \
  queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
  tensor_decoder mode=bounding_boxes option1=yolov8 option2=labels.txt option4=640:512 option5=320:320 ! \
  videoscale ! videoconvert ! video/x-raw,width=640,height=512 ! \
  mix.sink_0 \
  t. ! queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
  videoconvert ! mix.sink_1 \
  compositor name=mix sink_0::zorder=2 sink_1::zorder=1 ! videoconvert ! autovideosink sync=false