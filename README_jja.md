Forked from:
* https://gitlab.com/101/galliumos-sane-battery-indicator

My version makes multiple attempts to get a good icon,
as upower sometimes reports bad or missing data.
I've also fixed the icon used for <10% charge.

Example data:

````
upower -i /org/freedesktop/UPower/devices/battery_BAT0

  native-path:          BAT0
  vendor:               LGC
  model:                AC14B8K
  serial:               9A3E
  power supply:         yes
  updated:              Wed 14 Aug 2019 07:25:31 AM MDT (117 seconds ago)
  has history:          yes
  has statistics:       yes
  battery
    present:             yes
    rechargeable:        yes
    state:               discharging
    warning-level:       none
    energy:              38.3496 Wh
    energy-empty:        0 Wh
    energy-full:         42.636 Wh
    energy-full-design:  48.944 Wh
    energy-rate:         14.3944 W
    voltage:             16.938 V
    time to empty:       2.7 hours
    percentage:          90%
    capacity:            87.1118%
    technology:          lithium-ion
    icon-name:          'battery-full-symbolic'
````

See also `/usr/share/icons`

View the icons used: `more icons/24/*svg`
