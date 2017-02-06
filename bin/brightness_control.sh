#!/usr/bin/env bash

function usage {
    echo ""
    echo "usage> $0 <diff>"
    echo ""
    echo "- diff: [+|-]NUMBER" 
    echo ""
}

if [[ $# != 1 ]]; then
    usage
    exit 1
fi

# init
XBACKLIGHT=$(which xbacklight)
DIFF=$1

if [[ ! $XBACKLIGHT ]]; then
    exit 1
fi

$XBACKLIGHT $1
$XBACKLIGHT -get | cut -d'.' -f1
