#!/bin/bash

#Function for image scale parameters
scaleimage () {
echo "Scale image? (y/n)"
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
}

# Image to JPG conversion. Supports quality level
jpg () {
echo "Quality level"
read qualitylevel
scaleimage
ffmpeg -i "$inputfile" -qmin 1 -q $qualitylevel $scaleresult imageresult.jpg
}

# Image to PNG conversion.
png () {
scaleimage
ffmpeg -i "$inputfile" $scaleresult imageresult.png
}

# Image to TIFF conversion. Supports multiple algorithms
tiff () {
echo "Compression algorithm (packbits, raw, lzw, deflate)"
read compalg
scaleimage
ffmpeg -i "$inputfile" -compression_algo $compalg $scaleresult imageresult.tiff
}

# Image to WEBP conversion. Supports lossless and quality level
webp () {
echo "Lossless image? (y/n)"
read lossanswer
if [ ${lossanswer,,} == "y" ] || [ ${lossanswer,,} == "yes" ]
then
    lossanswer="1"
else
    lossanswer="0"
fi
echo "Quality? (0-100)"
read qualitylevel
scaleimage
ffmpeg -i "$inputfile" -lossless $lossanswer -quality $qualitylevel $scaleresult imageresult.webp
}

bmp () {
scaleimage
ffmpeg -i "$inputfile" $scaleresult imageresult.bmp
}

echo "Input file"
read inputfile
echo "Format to transcode to (jpg png tiff webp bmp)"
read format
case ${format,,} in
jpg)
    jpg
;;
png)
    png
;;
tiff)
    tiff
;;
webp)
    webp
;;
bmp)
    bmp
;;
esac
