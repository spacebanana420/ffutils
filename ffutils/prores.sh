#!/bin/bash

audioparameters ()  {
    case ${audioencode,,} in
    original)
    audioparams="-c:a copy"
    ;;
    pcm16)
    audioparams="-c:a pcm_s16le"
    ;;
    pcm24)
    audioparams="-c:a pcm_s24le"
    ;;
    esac
}

echo "Input file"
read inputfile
echo "Profile? (proxy, lt, standard, hq, 4444, 4444xq) (not case sensitive)"
read profile
echo "Audio encoding? (original, pcm16, pcm24) (not case sensitive)"
read audioencode
audioparameters
case ${profile,,} in
lt || standard || hq)
    ffmpeg -i "$inputfile" -c:v prores_ks -profile:v ${profile,,} $audioparams -pix_fmt yuv422p10le prores_$inputfile
;;
4444 || 4444xq)
    ffmpeg -i "$inputfile" -c:v prores_ks -profile:v ${profile,,} $audioparams -pix_fmt yuv444p10le prores_$inputfile
;;
esac
