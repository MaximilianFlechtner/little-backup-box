#!/usr/bin/env bash

# Author: Dmitri Popov, dmpop@linux.com

#######################################################################
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#######################################################################

# Don't start as root
if [[ $EUID -eq 0 ]]; then
   echo "Run the script as a regular user"
   exit 1
fi

sudo mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.old
sudo apt install -y comitup
sudo bash -c 'echo "ap_name: little-backup-box-<nn>" >> "/etc/comitup.conf"'
dialog --clear \
   --title "Reboot" \
   --msgbox "All done! After reboot, connect to the little-backup-box-<nn> network and open http://10.41.0.1/" 7 70
clear
sudo reboot
