#!/bin/bash

SCALE=24

ICON_DIR=$(dirname "$0")"/icons/"$SCALE"/"
ICON_EXT="svg"
ICON_PREFIX="battery"
DEFICON=$ICON_DIR/battery-missing.svg

# try to get data several times
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
while [ $count -lt $max ]
do
  if [ $count -gt 0 ]
  then
    sleep 1
  fi
  count=$(( $count + 1 ))

# ###
# ### begin original script code

# To find out: `upower -d | grep /battery`
BATTERY_NAME="/org/freedesktop/UPower/devices/battery_BAT0"

read -N256 REQ <<<$(upower -i $BATTERY_NAME | grep -E "state|to\ full|time\ to\ empty|percentage" )

# example REQ values:
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

if [ $PERCENTAGE -lt 10 ]
then
 PERCENT_ICON="000"
else
 PERCENT_ICON="0"${PERCENTAGE:0:1}"0"
fi

# echo $(( 10#$x ))

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

case $AC in
    "fully-charged")
    echo "<tool><b>${AC^}</b></tool>"
;;

    *)
    echo "<tool><b>${AC^} ($PERCENTAGE%)"
    echo "$ETA left.</b></tool>"
;;    
esac

echo "<click>xfce4-power-manager-settings</click>"

exit 0

# ### end original script code
# ###
done

# loop ended with no good data found, output something
echo "<img>$DEFICON</img>"
echo "<tool><b>unknown (AC=${AC},"
echo "PERCENTAGE=${PERCENTAGE})</b></tool>"
echo "<click>xfce4-power-manager-settings</click>"
exit 0
