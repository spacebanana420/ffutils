#!/bin/bash
echo "Input file"
read inputfile
echo "Choose a preset (from ultrafast to placebo)"
read preset
echo "Audio copy? (y/n)"
read copy
echo "CRF?"
read crf
if [ ${copy,,} == y ] || [ ${copy,,} == yes ]
    then
    ffmpeg -i "$inputfile" -c:v libx264 -preset:v $preset -crf $crf -c:a copy -pix_fmt yuv420p -bf 16 deliverytrans.mov
    else
    echo "Audio bitrate?"
    read audiobitrate
    ffmpeg -i "$inputfile" -c:v libx264 -preset:v $preset -crf $crf -c:a libopus -b:a $audiobitrate -pix_fmt yuv420p -bf 16 deliverytrans.mov
fi
