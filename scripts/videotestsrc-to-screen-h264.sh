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

set -ex
ROOT_DIR=$(readlink -f $(dirname $0)/..)

gst-launch-1.0 \
-v \
  videotestsrc name=src is-live=true do-timestamp=true \
! video/x-raw,width=160,height=120,framerate=30/1 \
! x264enc \
! mpegtsmux \
! decodebin \
! videoconvert \
! autovideosink
