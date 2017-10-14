#!/usr/bin/env bash

function usage() {
    echo ""
    echo "usage: $0 FILE..."
    echo ""
}

if [[ $# < 1 ]]; then
    usage
    exit 1
fi

FILES=$@
#NFILES=$(echo $(echo "$FILES" | wc -l)) # to trim leading white spaces of result of wc
NFILES=$#

echo "*** stabilize video"
i=0
for f in $FILES; do
    i=$((i + 1))
    echo "$i. $f"
done
echo -n "--- $NFILES ? [y/n] "
read YORN
if [[ $YORN != "y" ]]; then
    echo "... quit"
    exit 1
fi

i=0
TMPFILE=$(mktemp)
echo $TMPFILE

for f in $FILES; do
    i=$((i + 1))
    echo "- ($i/$NFILES) $f"

    # ffmpeg vib.stab
    #
    # all parameters are currently given default values
    #
    # - ref: https://github.com/georgmartius/vid.stab
    # - ex: https://www.epifocal.net/blog/video-stabilization-with-ffmpeg
    echo -n "  analyze video..."
    ffmpeg \
        -i $f \
        -vf vidstabdetect=shakiness=10:accuracy=15:stepsize=10:mincontrast=0.3:show=0:result="$TMPFILE" \
        -f null - \
        > /dev/null || { echo "error"; exit 1; }
    echo "ok"

    echo -n "  transform video..."
    FN=$(echo ${f%.*})
    #EXT=$(echo ${f##*.})
    EXT=MP4
    ffmpeg \
        -i $f \
        -vf vidstabtransform=zoom=1:smoothing=30:input="$TMPFILE",unsharp=5:5:0.8:3:3:0.4 -preset slow "${FN}_stab.$EXT" \
        > /dev/null || { echo "error"; exit 1; }
    echo "ok"
done
