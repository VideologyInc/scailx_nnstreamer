gst-launch-1.0 \
  v4l2src device=/dev/video-isi-csi1 ! video/x-raw,width=320,height=256,format=NV12 ! \
  videorate ! video/x-raw,framerate=10/1 ! \
  tee name=t \
  t. ! queue leaky=2 max-size-buffers=10 max-size-bytes=0 max-size-time=0 ! \
  videoscale ! videoconvert ! video/x-raw,width=320,height=320,format=RGB ! \
  tensor_converter ! \
  tensor_filter latency=1 framework=tensorflow2-lite model=thermal_yolov8n_320.tflite \
  custom=Delegate:External,ExtDelegateLib:libvx_delegate.so \
  accelerator=true:npu ! \
  tensor_transform mode=transpose option=1:0:2:3 ! \
  tensor_transform mode=arithmetic option=typecast:float32,add:-17,mul:0.006334480829536915 ! \
  tensor_decoder mode=bounding_boxes option1=yolov8 option2=thermal.txt option4=320:256 option5=320:320 ! \
  videoconvert ! \
  mix.sink_0 \
  t. ! queue leaky=2 max-size-buffers=10 max-size-bytes=0 max-size-time=0 ! \
  videoconvert ! mix.sink_1 \
  compositor name=mix sink_0::zorder=2 sink_1::zorder=1 ! \
  videoconvert ! autovideosink sync=false