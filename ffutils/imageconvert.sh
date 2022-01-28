#!/bin/bash

# Image to JPG conversion. Supports quality level
jpg () {
echo "Quality level"
read qualitylevel
echo "Scale image?"
read scaleanswer

if [ ${scaleanswer,,} == "yes" ] || [ ${scaleanswer,,} == "y" ]
then
    echo "Scale integer? (0.25; 0.5; 0.75; 1; 1.25; 1.5; 1.75; 2)"
    read scaleinteger
    ffmpeg -i "$inputfile" -qmin 1 -q $qualitylevel -vf scale=iw*${scaleinteger}:ih*${scaleinteger} imageresult.jpg
else
    ffmpeg -i "$inputfile" -qmin 1 -q $qualitylevel imageresult.jpg
fi
}

# Image to PNG conversion.
png () {
echo "Scale image?"
read scaleanswer
if [ ${scaleanswer,,} == "yes" ] || [ ${scaleanswer,,} == "y" ]
then
    echo "Scale integer? (0.25; 0.5; 0.75; 1; 1.25; 1.5; 1.75; 2)"
    read scaleinteger
    ffmpeg -i "$inputfile" -vf scale=iw*${scaleinteger}:ih*${scaleinteger} imageresult.png
else
    ffmpeg -i "$inputfile" imageresult.png
fi
}

# Image to TIFF conversion. Supports multiple algorithms
tiff () {
echo "Compression algorithm (packbits, raw, lzw, deflate)"
read compalg
echo "Scale image?"
read scaleanswer
if [ ${scaleanswer,,} == "yes" ] || [ ${scaleanswer,,} == "y" ]
then
    echo "Scale integer? (0.25; 0.5; 0.75; 1; 1.25; 1.5; 1.75; 2)"
    read scaleinteger
    ffmpeg -i "$inputfile" -compression_algo $compalg  -vf scale=iw*${scaleinteger}:ih*${scaleinteger} imageresult.tiff
else
    ffmpeg -i "$inputfile" -compression_algo $compalg  imageresult.tiff
fi
}

# Image to WEBP conversion. Supports lossless and quality level
webp () {
echo "Lossless image?"
read lossanswer
if [ ${lossanswer,,} == "y" ] || [ ${lossanswer,,} == "yes" ]
then
    lossanswer="1"
else
    lossanswer="0"
fi
echo "Quality? (0-100)"
read qualitylevel
echo "Scale image?"
read scaleanswer
if [ ${scaleanswer,,} == "yes" ] || [ ${scaleanswer,,} == "y" ]
then
    echo "Scale integer? (0.25; 0.5; 0.75; 1; 1.25; 1.5; 1.75; 2)"
    read scaleinteger
    ffmpeg -i "$inputfile" -lossless $lossanswer -quality $qualitylevel  -vf scale=iw*${scaleinteger}:ih*${scaleinteger} imageresult.webp
else
    ffmpeg -i "$inputfile" -lossless $lossanswer -quality $qualitylevel  imageresult.webp
fi
}

bmp () {
echo "Scale image?"
read scaleanswer
if [ ${scaleanswer,,} == "yes" ] || [ ${scaleanswer,,} == "y" ]
then
    echo "Scale integer? (0.25; 0.5; 0.75; 1; 1.25; 1.5; 1.75; 2)"
    read scaleinteger
    ffmpeg -i "$inputfile" -vf scale=iw*${scaleinteger}:ih*${scaleinteger} imageresult.bmp
else
    ffmpeg -i "$inputfile" imageresult.bmp
fi
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
