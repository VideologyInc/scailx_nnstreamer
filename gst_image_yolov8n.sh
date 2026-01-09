#!/usr/bin/env bash

gst-launch-1.0 \
    filesrc location=bus.jpg ! jpegdec ! videoscale ! videoconvert ! video/x-raw,width=810,height=1080,format=RGB ! tee name=t \
    t. ! queue leaky=2 max-size-buffers=2 ! videoscale ! videoconvert ! video/x-raw,width=320,height=320,format=RGB ! \
    tensor_converter ! \
    tensor_transform mode=arithmetic option=typecast:float32,add:0.0,div:255.0 ! \
    queue leaky=2 max-size-buffers=2 ! \
    tensor_filter latency=1 framework=tensorflow2-lite model=yolov8n_float16.tflite ! \
    tensor_transform mode=transpose option=1:0:2:3 ! \
    queue leaky=2 max-size-buffers=2 ! \
    tensor_decoder mode=bounding_boxes option1=yolov8 option2=coco.txt option4=810:1080 option5=320:320 ! \
    videoscale ! videoconvert ! video/x-raw,width=810,height=1080,format=RGBA ! compositor.sink_1 \
    t. ! queue leaky=2 max-size-buffers=2 ! videoconvert ! video/x-raw,width=810,height=1080,format=RGBA ! compositor.sink_0 \
    compositor name=compositor sink_1::zorder=2 sink_0::zorder=1 ! \
    queue leaky=2 max-size-buffers=2 ! \
    videoconvert ! pngenc ! filesink location=output.png