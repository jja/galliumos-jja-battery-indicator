#!/bin/bash

# A sane battery indicator for Xfce4
# Inspired by (and mostly stolen from) this comment https://forum.xfce.org/viewtopic.php?pid=47879#p47879
# To run it:



ICON_DIR="/home/liza/Projects/battery-indicator/icons2/"
ICON_EXT="svg"
ICON_PREFIX="battery"
BATTERY_NAME="/org/freedesktop/UPower/devices/battery_BAT0"

STATE=$(upower -i $BATTERY_NAME | grep -E "state|to\ full|time\ to\ empty|percentage" | grep state | tr -s " " | cut -d' ' -f3)
TOFULL=$(upower -i $BATTERY_NAME | grep -E "state|to\ full|percentage" | grep "to full" | tr -s " " | cut -d' ' -f5-)
TOEMPTY=$(upower -i $BATTERY_NAME | grep -E "state|to\ full|time\ to\ empty|percentage" | grep "time to empty" | tr -s " " | cut -d' ' -f5-)
PERCENTAGE=$(upower -i $BATTERY_NAME | grep -E "state|to\ full|time\ to\ empty|percentage" | grep "percentage" | tr -s " " | cut -d' ' -f3 | sed -e 's/\%//g')

case $STATE in
    "charging") STATE_SUFFIX="-charging" ;;
    "discharging") STATE_SUFFIX="" ;;    
    "fully-charged") STATE_SUFFIX="-full";;
esac

echo $(python3 -c "print($PERCENTAGE // 10)")

case $PERCENTAGE in
    [0-9]|[1-9][0-9]) PCT=0$(python3 -c "print($PERCENTAGE // 10)")0 ;;
    100) PCT="100" ;;     
    *) PCT="missing" ;;
esac

ICON=$ICON_DIR$ICON_PREFIX-$PCT$STATE_SUFFIX.$ICON_EXT 

case $STATE in
    "charging")
    echo "<img>$ICON</img><tool><b>Battery state:</b>
State:          $STATE
To Full:         $TOFULL
Percentage: $PERCENTAGE%</tool><click>xfce4-power-manager-settings</click>"
;;

    "discharging")
    echo "<img>$ICON</img><tool><b>Battery state:</b>
State:          $STATE
To Empty:    $TOEMPTY
Percentage: $PERCENTAGE%</tool><click>xfce4-power-manager-settings</click>"
;;    

    "fully-charged")
    echo "<img>$ICON</img><tool><b>Battery state:</b>
State:          $STATE
Percentage: $PERCENTAGE%</tool><click>xfce4-power-manager-settings</click>"
;;
esac

exit 0