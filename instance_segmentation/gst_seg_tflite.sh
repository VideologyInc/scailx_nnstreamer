#!/usr/bin/env bash

gst-launch-1.0 \
    v4l2src device=/dev/video0 ! \
        video/x-raw,format=NV12,width=320,height=320,framerate=15/1 ! \
        tee name=t \
    t. ! queue leaky=2 max-size-buffers=2 ! \
        videoconvert ! \
        mix.sink_1 \
    t. ! queue leaky=2 max-size-buffers=2 ! \
        videoconvert ! \
        videoscale ! \
        video/x-raw,format=RGB,width=257,height=257 ! \
        tensor_converter ! \
        tensor_transform mode=arithmetic option=typecast:float32,div:255.0 ! \
        tensor_filter framework=tensorflow-lite \
            model=tflite_img_segment_model/deeplabv3_257_mv_gpu.tflite ! \
        tensor_decoder mode=image_segment option1=tflite-deeplab ! \
        queue leaky=2 max-size-buffers=2 ! \
        videoscale ! videoconvert ! video/x-raw,width=320,height=320 ! \
        mix.sink_0 \
    compositor name=mix \
        sink_0::zorder=2 sink_0::alpha=0.6 \
        sink_1::zorder=1 sink_1::alpha=1.0 ! \
        queue leaky=2 max-size-buffers=2 ! \
        videoconvert ! \
        autovideosink sync=false