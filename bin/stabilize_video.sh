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

for f in $FILES; do
    i=$((i + 1))
    echo "- ($i/$NFILES) $f"

    # ffmpeg vib.stab
    #
    # all parameters are currently given default values
    #
    # - ref: ttps://github.com/georgmartius/vid.stab
    # - ex: https://www.epifocal.net/blog/video-stabilization-with-ffmpeg
    echo -n "  analyze video..."
    echo ffmpeg \
        -i $f \
        -vf vidstabdetect=shakiness=5:accuracy=15:stepsize=6:mincontrast=0.3:show=0:result="$TMPFILE" \
        -f null - \
        > /dev/null || { echo "error"; exit 1; }
    echo "ok"

    echo -n "  transform video..."
    FN=$(echo ${F%.*})
    EXT=$(echo ${F##*.})
    echo ffmpeg \
        -i $f \
        -vf vidstabtransform=input="$TMPFILE":zoom=0:smoothing=10,unsharp=5:5:0.8:3:3:0.4 "${FN}_stab.$EXT" \
        > /dev/null || { echo "error"; exit 1; }
    echo "ok"
done
