# Sane battery indicator

Xfce uses dumbed down battery indicator, which only has three states. This is a shell script for `xfce4-genmon-plugin` which makes it a little more nuanced.

## Installation

It is a bash script, that probably won't run on other shells, so `/bin/bash` is a prerequisite.

* `sudo apt install xfce4-genmon-plugin`
* `git clone https://gitlab.com/101/galliumos-sane-battery-indicator.git`
* `cd galliumos-sane-battery-indicator`
* `chmod +x battery-indicator.sh`
* Remove the old battery indicator from the Xfce panel.
* In the Xfce panel, create new "Generic monitor"

In the Generic monitor properties:

* Set command to the absolute path of `battery-indicator.sh`
* Set the refresh rate to whatever you like. E.g. 2 seconds.
* Uncheck "Label"

Enjoy.

## Usage

By default, icons are 24px. The script accepts optional parameter for different sizes, it can be 32, 48, 24 or 16.
Like this: `/path/to/script/battery-indicator.sh 48`.

## Design

If you don't like the icons, replace them in the `icons` folder. They will work, as long as they follow naming convention. Note, that many Xfce themes already have them.

## License

This project is licensed under the GNu GPL v3.0, inherited from the Numix project, since I used their icons - see the [LICENSE](LICENSE.md) file for details.

## Acknowledgments

* Hat tip to user ToZ at forum.xfce.org, who [inspired](https://forum.xfce.org/viewtopic.php?pid=47879#p47879) me.
* Icons used are from the [Numix project](http://numixproject.org/).
