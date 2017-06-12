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

echo "*** convert mov to mp4"
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

for f in $FILES; do
    i=$((i + 1))

    FN=$(echo ${f%.*})
    #EXT=$(echo ${f##*.})
    EXT=MP4

    NEWNAME=$FN.$EXT

    echo -n "- ($i/$NFILES) $f to $NEWNAME ... "

    if [[ -f $NEWNAME ]]; then
        echo "skip, already exists"
        continue
    fi

    ffmpeg \
        -i $f \
        -vcodec copy \
        -acodec aac \
        -ab 192k \
        $NEWNAME \
        > /dev/null 2>&1 || { echo "failed"; exit 1; }

    touch -d "$(date -R -r $f)" $NEWNAME

    echo "ok"
done
