#!/bin/bash

#Function for image scale parameters
scaleimage () {
echo "Scale image? (y/n)"
read scaleanswer

if [[ ${scaleanswer,,} == "yes" ]] || [[ ${scaleanswer,,} == "y" ]]
then
    echo "Choose a scaling method"
    echo "Factor manual"
    read type
    case $type in
    factor)
        echo "Scale factor? (example: 0.5; 1.25; 2)"
        read scalefactor
        if [[ $scalefactor == "0" ]] || [[ $scalefactor == "" ]] || [[ $scalefactor == "1" ]]
        then
            scaleresult=""
        else
            scaleresult="-vf scale=iw*${scalefactor}:ih*${scalefactor}"
        return
        ficpp
    ;;
    manual)
        echo "Width"
        read width
        echo "Height"
        read height
        scaleresult="-vf scale=${width}:${height}"
    ;;
    *)
        echo "Scale factor? (example: 0.5; 1.25; 2)"
        read scalefactor
        if [[ $scalefactor == "0" ]] || [[ $scalefactor == "" ]] || [[ $scalefactor == "1" ]]
        then
            scaleresult=""
        else
            scaleresult="-vf scale=iw*${scalefactor}:ih*${scalefactor}"
        return
        fi
    ;;
    esac

    interpolation="a"
    while [[ $interpolation != "bilinear" ]] && [[ $interpolation != "bicubic" ]] && [[ $interpolation != "nearest" ]] && [[ $interpolation != "lanczos" ]] && [[ $interpolation != "bicublin" ]] && [[ $interpolation != "" ]]
    do
        echo "Choose interpolation"
        echo "bilinear, bicubic, nearest, lanczos, bicublin (default=bicubic)"
        read interpolation
    done
    if [[ $interpolation != "" ]]
    then
        scaleresult+=":flags=$interpolation"
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
if [[ $inputfile == "batch" ]]
then
    mkdir Result_jpg
    for i in *
    do
    i2= $(basename $i .$informat)
        if [[ $inputfile == *".png"* ]] || [[ $inputfile == *".tiff"* ]] || [[ $inputfile == *".tif"* ]] || [[ $inputfile == *".jpg"* ]] || [[ $inputfile == *".webp"* ]] || [[ $inputfile == *".bmp"* ]] || [[ $inputfile == *".avif"* ]] || [[ $inputfile == *".heic"* ]] || [[ $inputfile == *".heif"* ]]
        then
            ffmpeg -i "$inputfile" -qmin 1 -q $qualitylevel $scaleresult Result_$i2.jpg
            mv Result_$i2.jpg Result_jpg
        fi
    done
    echo "Archive and encrypt folter? (y/n)"
    read encrypt
    if [[ $encrypt == "y"]]
    then
        zip -0 -e -v Result_jpg.zip Result_jpg
    fi
else
    i2= $(basename $inputfile .$informat)
    ffmpeg -i "$inputfile" -qmin 1 -q $qualitylevel $scaleresult Result_$i2.jpg
fi
}

# Image to PNG conversion.
png () {
scaleimage
if [[ $inputfile == "batch" ]]
then
    mkdir Result_png
    for i in *
    do
    i2= $(basename $i .$informat)
        if [[ $inputfile == *".png"* ]] || [[ $inputfile == *".tiff"* ]] || [[ $inputfile == *".tif"* ]] || [[ $inputfile == *".jpg"* ]] || [[ $inputfile == *".webp"* ]] || [[ $inputfile == *".bmp"* ]] || [[ $inputfile == *".avif"* ]] || [[ $inputfile == *".heic"* ]] || [[ $inputfile == *".heif"* ]]
        then
            ffmpeg -i "$inputfile" $scaleresult Result_$i2.png
            mv Result_$i2.png Result_png
        fi
    done
    echo "Archive and encrypt folter? (y/n)"
    read encrypt
    if [[ $encrypt == "y"]]
    then
        zip -0 -e -v Result_png.zip Result_png
    fi
else
    i2= $(basename $inputfile .$informat)
    ffmpeg -i "$inputfile" $scaleresult Result_$i2.png
fi
}

# Image to TIFF conversion. Supports multiple algorithms
tiff () {
echo "Compression algorithm (packbits, raw, lzw, deflate)"
read compalg
scaleimage
if [[ $inputfile == "batch" ]]
then
    mkdir Result_tiff
    for i in *
    do
    i2= $(basename $i .$informat)
        if [[ $inputfile == *".png"* ]] || [[ $inputfile == *".tiff"* ]] || [[ $inputfile == *".tif"* ]] || [[ $inputfile == *".jpg"* ]] || [[ $inputfile == *".webp"* ]] || [[ $inputfile == *".bmp"* ]] || [[ $inputfile == *".avif"* ]] || [[ $inputfile == *".heic"* ]] || [[ $inputfile == *".heif"* ]]
        then
            ffmpeg -i "$inputfile" -compression_algo $compalg $scaleresult Result_$i2.tiff
            mv Result_$i2.tiff Result_tiff
        fi
    done
    echo "Archive and encrypt folter? (y/n)"
    read encrypt
    if [[ $encrypt == "y"]]
    then
        zip -0 -e -v Result_tiff.zip Result_tiff
    fi
else
    i2= $(basename $inputfile .$informat)
    ffmpeg -i "$inputfile" -compression_algo $compalg $scaleresult Result_$i2.tiff
fi
}

# Image to WEBP conversion. Supports lossless and quality level
webp () {
echo "Lossless image? (y/n)"
read lossanswer
if [[ ${lossanswer,,} == "y" ]] || [[ ${lossanswer,,} == "yes" ]]
then
    lossanswer="1"
else
    lossanswer="0"
fi
echo "Quality? (0-100)"
read qualitylevel
scaleimage
if [[ $inputfile == "batch" ]]
then
    mkdir Result_webpcpp
    for i in *
    do
    i2= $(basename $i .$informat)
        if [[ $inputfile == *".png"* ]] || [[ $inputfile == *".tiff"* ]] || [[ $inputfile == *".tif"* ]] || [[ $inputfile == *".jpg"* ]] || [[ $inputfile == *".webp"* ]] || [[ $inputfile == *".bmp"* ]] || [[ $inputfile == *".avif"* ]] || [[ $inputfile == *".heic"* ]] || [[ $inputfile == *".heif"* ]]
        then
            ffmpeg -i "$inputfile" -lossless $lossanswer -quality $qualitylevel $scaleresult Result_$i2.webp
            mv Result_$i2.webp Result_webp
        fi
    done
    echo "Archive and encrypt folter? (y/n)"
    read encrypt
    if [[ $encrypt == "y"]]
    then
        zip -0 -e -v Result_webp.zip Result_webp
    fi
else
    i2= $(basename $inputfile .$informat)
    ffmpeg -i "$inputfile" -lossless $lossanswer -quality $qualitylevel $scaleresult Result_$i2.webp
fi
}

bmp () {
scaleimage
if [[ $inputfile == "batch" ]]
then
    mkdir Result_bmp
    for i in *
    do
    i2= $(basename $i .$informat)
        if [[ $inputfile == *".png"* ]] || [[ $inputfile == *".tiff"* ]] || [[ $inputfile == *".tif"* ]] || [[ $inputfile == *".jpg"* ]] || [[ $inputfile == *".webp"* ]] || [[ $inputfile == *".bmp"* ]] || [[ $inputfile == *".avif"* ]] || [[ $inputfile == *".heic"* ]] || [[ $inputfile == *".heif"* ]]
        then
            ffmpeg -i "$inputfile" $scaleresult Result_$i2.bmp
            mv Result_$i2.bmp Result_bmp
        fi
    done
    echo "Archive and encrypt folter? (y/n)"
    read encrypt
    if [[ $encrypt == "y"]]
    then
        zip -0 -e -v Result_bmp.zip Result_bmp
    fi
else
    i2= $(basename $inputfile .$informat)
    ffmpeg -i "$inputfile" $scaleresult Result_$i2.bmp
fi
}
echo "Script directory? (y/n)"cpp
read diranswer
if [[ ${diranswer,,} == "n" ]]
then
    echo "Write the file directory"
    read dir
    cd $dir
fi
echo "Input file (write 'batch' to encode all images inside a directory)"
read inputfile
echo "Input Format"
read informat
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
