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
echo "Profile? (DNxHD, LB, SQ, HQ, HQX, 444) (not case sensitive)"
read profile
echo "Audio encoding? (original, pcm16, pcm24) (not case sensitive)"
read audioencode
audioparameters
case ${profile,,} in
dnxhd)
    ffmpeg -i "$inputfile" -c:v dnxhd -profile:v dnxhd $audioparams -pix_fmt yuv422p dnxhd_$inputfile
;;
lb || sq || hq)
    ffmpeg -i "$inputfile" -c:v dnxhd -profile:v dnxhr_${profile,,} $audioparams -pix_fmt yuv422p dnxhr_$inputfile
;;
hqx)
    ffmpeg -i "$inputfile" -c:v dnxhd -profile:v dnxhr_hqx $audioparams -pix_fmt yuv422p10le dnxhr_$inputfile
;;
444)
    ffmpeg -i "$inputfile" -c:v dnxhd -profile:v dnxhr_444 $audioparams -pix_fmt yuv444p10le dnxhr_$inputfile
;;
esac
