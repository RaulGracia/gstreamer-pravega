#!/bin/bash

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

# Use --privileged to allow core dumps.
docker run -it --rm \
    --network host \
    --privileged \
    --user root \
    --log-driver json-file --log-opt max-size=10m --log-opt max-file=2 \
    -e ENTRYPOINT='/usr/src/gstreamer-pravega/python_apps/pravega_latency_reader.py --scope test' \
    pravega/gstreamer:pravega-prod