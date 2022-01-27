#!/bin/bash

audioparams () {
case $audioencoder in
    copy || original || copy original)
        audioencoding="-c:a copy"
    ;;
    opus)
        echo "Audio bitrate?"
        read audiobitrate
        audioencoding="-c:a libopus -b:a $audiobitrate"
    ;;
    aac)
        echo "Audio bitrate?"
        read audiobitrate
        audioencoding="-c:a aac -b:a $audiobitrate"
    ;;
    flac)
        audioencoding="-c:a flac"
    ;;
    pcm || wav)
        echo "Audio bit depth?"
        read audiodepth
        audioencoding="-c:a pcm_s${audiodepth}le"
    ;;
    mp3)
        echo "Audio bitrate?"
        read audiobitrate
        audioencoding="-c:a libmp3lame -b:a $audiobitrate"
    ;;
esac
}

echo "Input file"
read inputfile
echo "Choose a preset (from ultrafast to placebo)"
read preset
echo "Select the audio encoding (copy original, opus, aac, flac, pcm, mp3)"
read audioencoder
echo "CRF?"
read crf
ffmpeg -i "$inputfile" -c:v libx264 -preset:v $preset -crf $crf $audioencoding -pix_fmt yuv420p -bf 16 delivery_x264.mov
