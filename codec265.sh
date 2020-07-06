#!/bin/bash

ffmpeg -y -f image2 -i $1 -vcodec hevc -an -crf $2 $1_$2.h265
ffmpeg -y -i $1_$2.h265 $1_$2_rebuild.ppm