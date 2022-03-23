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
        fi
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

ffcommand () {
    scaleimage
    case ${profile,,} in
    dnxhd)
        ffmpeg -i "$inputfile" -c:v dnxhd -profile:v dnxhd $audioparams $fpsparam $scaleresult -pix_fmt yuv422p dnxhdresult$num.mov
    ;;
    lb | sq | hq)
        ffmpeg -i "$inputfile" -c:v dnxhd -profile:v dnxhr_${profile,,} $fpsparam $audioparams $scaleresult -pix_fmt yuv422p dnxhrresult$num.mov
    ;;
    hqx)
        ffmpeg -i "$inputfile" -c:v dnxhd -profile:v dnxhr_hqx $audioparams $fpsparam $scaleresult -pix_fmt yuv422p10le dnxhrresult$num.mov
    ;;
    444)
        ffmpeg -i "$inputfile" -c:v dnxhd -profile:v dnxhr_444 $audioparams $fpsparam $scaleresult -pix_fmt yuv444p10le dnxhrresult$num.mov
    ;;
    *)
        ffmpeg -i "$inputfile" -c:v dnxhd -profile:v dnxhr_${profile,,} $fpsparam $audioparams $scaleresult -pix_fmt yuv422p dnxhrresult$num.mov
    ;;
    esac
}
echo "Script directory? (y/n)"
read diranswer
if [[ ${diranswer,,} == "n" ]]
then
    echo "Write the file directory"
    read dir
    cd $dir
fi
echo "Input file"
echo "Type 'batch' to transcode all video files in current directory"
read inputfile
echo "Profile? (dnxhd, lb, sq, hq, hqx, 444)"
read profile
echo "Audio encoding?"
echo "copy, pcm16, pcm24"
read audioencode
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

case ${audioencode,,} in
original | none | copy)
    audioparams="-c:a copy"
;;
pcm16)
    audioparams="-c:a pcm_s16le"
;;
pcm24)
    audioparams="-c:a pcm_s24le"
;;
*)
    audioparams="-c:a copy"
;;
esac
if [[ $inputfile != "batch" ]]
then
    num=""
    ffcommand
else
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
fi
echo "All is done!"
