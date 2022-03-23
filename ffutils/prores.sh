#!/bin/bash
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
case ${profile,,} in
lt | standard | hq)
    ffmpeg -i "$inputfile" -c:v prores_ks -profile:v ${profile,,} $scaleresult $audioparams -pix_fmt yuv422p10le proresresult$num.mov
;;
4444 | 4444xq)
    ffmpeg -i "$inputfile" -c:v prores_ks -profile:v ${profile,,} $scaleresult $audioparams -pix_fmt yuv444p10le proresresult$num.mov
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
read inputfile
echo "Profile? (proxy, lt, standard, hq, 4444, 4444xq) (not case sensitive)"
read profile
echo "Audio encoding? (original, pcm16, pcm24) (not case sensitive)"
read audioencode
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
scaleimage

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
