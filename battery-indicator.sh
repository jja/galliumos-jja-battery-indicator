#!/bin/bash

ICON_DIR=$(dirname "$0")"/icons/"
ICON_EXT="svg"
ICON_PREFIX="battery"

# To find out: `upower -d | grep /battery`
BATTERY_NAME="/org/freedesktop/UPower/devices/battery_BAT0"

read -N256 REQ <<<$(upower -i $BATTERY_NAME | grep -E "state|to\ full|time\ to\ empty|percentage" )
arrState=($REQ)

AC=${arrState[1]}
ETA=${arrState[5]}\ ${arrState[6]}
PERCENTAGE=${arrState[8]//%/}
PERCENT_ICON="0"${PERCENTAGE:0:1}"0"

case $AC in
    "charging") SUFFIX="-charging" ;;
    "discharging") SUFFIX="" ;;    
    "fully-charged") SUFFIX="" ;;
esac

case $PERCENTAGE in
    [0-9]|[1-9][0-9]) PCT=$PERCENT_ICON ;;
    100) PCT="100" ;;
    *) PCT="charged" ;;
esac

ICON=$ICON_DIR$ICON_PREFIX-$PCT$SUFFIX.$ICON_EXT 

echo "<img>$ICON</img>"

case $AC in
    "fully-charged")
    echo "<tool><b>${AC^}</b></tool>"
;;

    *)
    echo "<tool><b>${AC^} ($PERCENTAGE%)
$ETA left.</b></tool>"
;;    
esac

echo "<click>xfce4-power-manager-settings</click>"

exit 0