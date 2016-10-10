#!/usr/bin/env bash

function usage() {
    echo "usage) $0"
    echo ""
    echo "-p: suspend when no AC connected, otherwise always"
    echo "-l: lock command to execute before suspend"
}

SUSPEND_NO_AC=0
LOCK=""

while getopts "pl:h" opt; do
    case $opt in
        p)
            SUSPEND_NO_AC=1
            ;;
        l)
            LOCK="$OPTARG"
            ;;
        h)
            usage
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
    esac
done

AC_CONNECTED=$(cat /sys/class/power_supply/AC/online)

# suspend if
# a. no -p option
# b. -p option and no ac connected
if [[ $SUSPEND_NO_AC == 0 || $AC_CONNECTED == 0 ]] ; then
    systemctl suspend
    exit 0
fi

# only lock
if [[ $LOCK != "" ]]; then
    $LOCK
fi
