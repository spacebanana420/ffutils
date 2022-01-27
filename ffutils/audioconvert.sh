#!/bin/bash
echo "Input file"
read inputfile
echo -e "Choose an encoder:\n""PCM (wav)\nmp3 (mpegaudio)\naac\nopus (ogg)\nvorbis (ogg)"
read encoder
case ${encoder,,} in
pcm)
    echo "Bit depth? (16/24)"
    read $depth
    if [ $depth = 16 ] || [ $depth = 24 ]
    then
        ffmpeg -i "$inputfile" -c:v pcm_s${depth}le audioresult.wav
    else
        echo "Incorrect bit depth value"
    fi
;;
mp3 || mpegaudio || mpeg audio)
    echo "Bitrate?"
    read $audiorate
    ffmpeg -i "$inpufile" -c:v libmp3lame -b:a $audiorate audioresult.mp3
;;
opus || ogg opus)
    echo "Bitrate?"
    read $audiorate
    ffmpeg -i "$inputfile" -c:v libopus -b:a $audiorate audioresult.ogg
;;
vorbis || ogg vorbis)
;;
esac
