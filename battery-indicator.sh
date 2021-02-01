#!/bin/bash

# Usage: battery-indicator.sh [-m max_retries]

SCALE=24

ICON_DIR=$(dirname "$0")"/icons/"$SCALE"/"
ICON_EXT="svg"
ICON_PREFIX="battery"
DEFICON=$ICON_DIR/battery-missing.svg

count=0
max=10

if [ "$1" = "-m" ]
then
    shift;
    if [ -n "$1" ]
    then
        max=$1
        shift;
    fi
fi

# try to get data several times
while [ $count -lt $max ]
do
    if [ $count -gt 0 ]
    then
        sleep 1
    fi
    count=$(( $count + 1 ))


    # To find out: `upower -d | grep /battery`
    BATTERY_NAME="/org/freedesktop/UPower/devices/battery_BAT0"

    grepexpr="state:|time to|percentage"
    read -N256 REQ <<<$(upower -i $BATTERY_NAME | grep -E "$grepexpr" )

    # example REQ values:
    #  state:               fully-charged
    #  state: charging time to full: 49.5 minutes percentage: 54%
    #  state: discharging time to empty: 24.3 minutes percentage: 8%

    if [ -z "$REQ" ]
    then
        continue
    fi

    arrState=($REQ)
    AC=${arrState[1]}
    ETA=${arrState[5]}\ ${arrState[6]}
    PERCENTAGE=${arrState[8]//%/}
    #echo "AC $AC ETA $ETA PERCENTAGE $PERCENTAGE" 1>&2

    if [ 0"$PERCENTAGE" -lt 10 ]
    then
        PERCENT_ICON="000"
    elif [ 0"$PERCENTAGE" -gt 98 ]
    then
        PERCENT_ICON="100"
    else
        PERCENT_ICON="0"${PERCENTAGE:0:1}"0"
    fi

    case $AC in
        "charging") SUFFIX="-charging" ;;
        "discharging") SUFFIX="" ;;
        "fully-charged")
            SUFFIX="charged"
            PERCENT_ICON=""
            ;;
    esac

    ICON=$ICON_DIR$ICON_PREFIX-$PERCENT_ICON$SUFFIX.$ICON_EXT

    if [ ! -e "$ICON" ]
    then
        echo "$0" "no icon, continuing to try again..." 1>&2
        echo "REQ=$REQ" 1>&2
        echo "AC=$AC" 1>&2
        echo "PERCENTAGE=$PERCENTAGE" 1>&2
        echo "ICON=$ICON" 1>&2
        continue
    fi

    echo "<img>$ICON</img>"

    echo -n "<tool><b>${AC^}"
    if [ "$AC" != "fully-charged" ]
    then
        echo " ($PERCENTAGE%)"
        echo -n "$ETA left."
    fi
    echo "</b></tool>"

    echo "<click>xfce4-power-manager-settings</click>"

    exit 0

done

# loop ended with no good data found, output something
echo "<img>$DEFICON</img>"
echo "<tool><b>unknown (AC=${AC},"
echo "PERCENTAGE=${PERCENTAGE})</b></tool>"
echo "<click>xfce4-power-manager-settings</click>"
exit 0
