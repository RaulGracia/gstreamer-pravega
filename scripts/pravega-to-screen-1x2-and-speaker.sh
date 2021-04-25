#!/usr/bin/env bash

#
# Copyright (c) Dell Inc., or its subsidiaries. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#


# 2 video streams and 2 audio streams will be read from 4 separate Pravega streams as MPEG Transport Streams.
# They will be displayed in a single window side by side.
# Audio will be mixed and output to the speaker.
# This will read data generated by avtestsrc-to-pravega-1x2.sh.

set -ex
ROOT_DIR=$(readlink -f $(dirname $0)/..)
pushd ${ROOT_DIR}/gst-plugin-pravega
cargo build
ls -lh ${ROOT_DIR}/gst-plugin-pravega/target/debug/*.so
export GST_PLUGIN_PATH=${ROOT_DIR}/gst-plugin-pravega/target/debug:${GST_PLUGIN_PATH}
export GST_DEBUG="pravegasrc:INFO,basesrc:INFO,mpegtsbase:INFO,mpegtspacketizer:INFO"
export RUST_BACKTRACE=1
export GST_DEBUG_DUMP_DOT_DIR=/tmp/gst-dot/pravega-to-screen-1x2-and-speaker
mkdir -p ${GST_DEBUG_DUMP_DOT_DIR}
PRAVEGA_STREAM=${PRAVEGA_STREAM:-group1}
WIDTH=320
HEIGHT=240

gst-launch-1.0 \
-v \
pravegasrc stream=examples/${PRAVEGA_STREAM}-v1 \
! tsdemux \
! h264parse \
! avdec_h264 \
! videoconvert \
! comp. \
pravegasrc stream=examples/${PRAVEGA_STREAM}-v2 \
! tsdemux \
! h264parse \
! avdec_h264 \
! videoconvert \
! comp. \
compositor name=comp \
sink_0::xpos=0 sink_0::ypos=0 sink_0::width=$WIDTH sink_0::height=$HEIGHT \
sink_1::xpos=$WIDTH sink_1::ypos=0 sink_1::width=$WIDTH sink_1::height=$HEIGHT \
sink_2::xpos=0 sink_2::ypos=$HEIGHT sink_2::width=$WIDTH sink_2::height=$HEIGHT \
sink_3::xpos=$WIDTH sink_3::ypos=$HEIGHT sink_3::width=$WIDTH sink_3::height=$HEIGHT \
! autovideosink \
pravegasrc stream=examples/${PRAVEGA_STREAM}-a1 \
! tsdemux \
! avdec_aac \
! audioconvert \
! audioresample \
! mixer. \
pravegasrc stream=examples/${PRAVEGA_STREAM}-a2 \
! tsdemux \
! avdec_aac \
! audioconvert \
! audioresample \
! mixer. \
audiomixer name=mixer \
! autoaudiosink
