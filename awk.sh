#!/bin/bash


BATTERY_NAME="/org/freedesktop/UPower/devices/battery_BAT0"

echo $(upower -i $BATTERY_NAME | grep -E "state|to\ full|time\ to\ empty|percentage" )

de=$(upower -i $BATTERY_NAME | grep -E "state|to\ full|time\ to\ empty|percentage" )

echo   \(\) $de \(\) 