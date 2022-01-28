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
echo "Quality level? (0-12 best-worst)"
read qualitylevel
echo "Audio encoding? (original, pcm16, pcm24) (not case sensitive)"
read audioencode
audioparameters
ffmpeg -i "$inputfile" -c:v cfhd -quality $qualitylevel $audioparams -pix_fmt yuv422p10le cfhdresult.mov
