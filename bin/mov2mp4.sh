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

FILES=( "$@" ) # store given argument files as array variable
NFILES=$#

echo "*** convert mov to mp4"
i=0
for f in "${FILES[@]}"; do
    i=$((i + 1))
    echo "$i. $f"
done
echo -n "--- $i ? [y/n] "
read YORN
if [[ $YORN != "y" ]]; then
    echo "... quit"
    exit 1
fi

i=0

for f in "${FILES[@]}"; do
    i=$((i + 1))

    FN=$(echo ${f%.*})
    EXT=MP4

    NEWNAME=$FN.$EXT

    echo -n "- ($i/$NFILES) $f to $NEWNAME ... "

    if [[ -f "$NEWNAME" ]]; then
        echo "skip, already exists"
        continue
    fi

    # simply just change container
    # but audio for mp4 by ffmpeg settings
    ffmpeg \
        -i "$f" \
        -vcodec copy \
        -map_metadata:s:v 0:s:v \
        -map_metadata:s:a 0:s:a \
        "$NEWNAME" \
        > /dev/null 2>&1 || { echo "failed"; exit 1; }
        # -acodec copy \ - does not work
        #-acodec aac -ab 192k \ - need conversion using cpu

    # update mtime the same as the old
    MTIME=$(date -R -r "$f")
    touch -d "$MTIME" "$NEWNAME"

    echo "ok"
done
