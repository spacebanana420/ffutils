#!/bin/bash

echo "Input file"
read inputfile
echo "Choose a preset (from ultrafast to placebo)"
read preset
echo "Select the audio encoding (copy original, opus, aac, flac, pcm, mp3)"
read audioencoder
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
echo "CRF?"
read crf
echo "Scale video? (y/n)"
read scaleanswer

if [ ${scaleanswer,,} == "yes" ] || [ ${scaleanswer,,} == "y" ]
then
    echo "Scale factor? (example: 0.5; 1.25; 2)"
    read scalefactor
    if [ $scalefactor == "0" ] || [ $scalefactor == "" ] || [ $scalefactor == "1" ]
    then
        scaleresult=""
        return
    fi
    interpolation="a"
    while [[ $interpolation != "bilinear" ]] && [[ $interpolation != "bicubic" ]] && [[ $interpolation != "nearest" ]] && [[ $interpolation != "lanczos" ]] && [[ $interpolation != "bicublin" ]] && [[ $interpolation != "" ]]
    do
        echo "Choose interpolation (bilinear, bicubic, nearest, lanczos, bicublin) (default=bicubic)"
        read interpolation
    done
    if [ $interpolation != "bilinear" ] || [ $interpolation != "bicubic" ] || [ $interpolation != "nearest" ] || [ $interpolation != "lanczos" ] || [ $interpolation != "bicublin" ]
    then
        scaleresult="-vf scale=iw*${scalefactor}:ih*${scalefactor}"

    else
        scaleresult="-vf scale=iw*${scalefactor}:ih*${scalefactor}:flags=$interpolation"
    fi
else
    scaleresult=""
fi
echo "Subsample colour to 4:2:0? (y/n)?"
read subsample
if [ ${subsample,,} == y ] || [ ${subsample,,} == yes ]
then
    ffmpeg -i "$inputfile" -c:v libx264 -preset:v $preset -crf $crf $audioencoding $scaleresult -pix_fmt yuv420p delivery_x264.mov
else
    ffmpeg -i "$inputfile" -c:v libx264 -preset:v $preset -crf $crf $audioencoding $scaleresult delivery_x264.mov
fi
