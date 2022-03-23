#!/bin/bash

#Final ffmpeg command
ffcommand () {
ffmpeg -i "$inputfile" -c:v libx265 -preset:v $preset -crf $crf $fpsparam $keyframe $audioencoding $scaleresult $subsampling delivery_x265$num.$container
}

echo "Input file"
echo "Type 'batch' to transcode all video files in current directory"
read inputfile
echo "Choose a preset"
echo "ultrafast  superfast  veryfast  faster  fast  medium  slow  slower  veryslow  placebo"
read preset
if [[ $preset != "ultrafast" ]] && [[ $preset != "superfast" ]] && [[ $preset != "veryfast" ]] && [[ $preset != "faster" ]] && [[ $preset != "fast" ]] && [[ $preset != "medium" ]] && [[ $preset != "slow" ]] && [[ $preset != "slower" ]] && [[ $preset != "veryslow" ]] && [[ $preset != "placebo" ]] &&
then
    preset="veryfast"
fi
echo "Select the audio encoding (copy original, opus, aac, flac, pcm, mp3)"
read audioencoder

#Audio encoding ffmpeg parameters
case $audioencoder in
    copy | original)
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
    pcm | wav | none)
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

#CRF and video scaling options
echo "CRF?"
read crf
echo "Scale video? (y/n)"
read scaleanswer

#Video scaling and interpolation parameters
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
        echo "Choose interpolation method:"
        echo "bilinear, bicubic, nearest, lanczos, bicublin (default=bicubic)"
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
#Change framerate
echo "Change framerate (y/n)?"
read fpsdecision
if [[ ${fpsdecision,,} == "y" ]]
then
    echo "Write the new framerate"
    read fps
    fpsparam="-r $fps"
else
    fpsparam=""
fi

#Change pix_fmt
echo "Choose a colour subsampling"
echo "420   422   444   original/keep"
read subsampling
if [[ $subsampling != "420" ]] && [[ $subsampling != "422" ]] && [[ $subsampling != "444" ]] && [[ $subsampling != "original" ]] && [[ $subsampling != "keep" ]] && [[ $subsampling != "none" ]]
then
    subsampling=""
elif [[ $subsampling == "original" ]] || [[ $subsampling == "keep" ]] || [[ $subsampling == "none" ]]
else
    subsampling="-pix_fmt $subsampling"
fi

#Set a keyframe interval (blank for automatic)
echo "Keyframe interval"
read keyframe
if [[ $keyframe != "" ]] && [[ $keyframe != "0" ]]
then
    keyframe="-g $keyframe"
else
    keyframe=""
fi

if [[ $audioencoder == "opus" ]]
then
    container="mp4"
else
    container="mov"
fi

if [[ $inputfile != "batch" ]]
then
    #Execute the ffmpeg command once for the desired video file
    num=""
    ffcommand
else
    #Execute the ffmpeg command for all video files inside current directory
    count=0
    for i in *
    do
        if [[ $i == *".mov"* ]] || [[ $i == *".mp4"* ]] || [[ $i == *".avi"* ]] || [[ $i == *".mkv"* ]] || [[ $i == *".webm"* ]]
        then
            num="_$count"
            inputfile=$i
            ffcommand
            count+=1
        fi
    done
    echo "Do you wish to encrypt the videos or move them to a folder? (move/encrypt/none) (default=none)"
    read postencode
    if [[ $postencode == "move"]] || [[ $postencode == "encrypt"]]
    then
        mkdir delivery_x265
        count=0
        for i in *
        do
            num="_$count"
            if [[ $i == *"delivery_x265"*]]
            then
            count+=1
            mv delivery_x265$num.$container
            fi
        done
        if [[ $postencode == "encrypt" ]]
        then
            zip -0 -erv delivery_x265.zip delivery_x265
        fi

    fi
fi
echo "All is done!"
