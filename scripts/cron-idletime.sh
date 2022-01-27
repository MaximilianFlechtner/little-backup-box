#!/usr/bin/env bash

# Author: Stefan Saam, github@saams.de

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

### Checks the idle-time of the Little Backup Box and powers down the system
WORKING_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${WORKING_DIR}/constants.sh"
CONFIG="${WORKING_DIR}/config.cfg"
source "$CONFIG"

#load language library
. "${WORKING_DIR}/lib-language.sh"

APACHE_ACCESS_LOGFILE="/var/log/apache2/lbb-access.log"

if [ "$conf_POWER_OFF_IDLE_TIME" -gt "0" ]; then

	IDLE_SEC_to_POWER_OFF=$(($conf_POWER_OFF_IDLE_TIME * 60))
	if [ -f "$const_UPDATE_LOCKFILE" ]; then UPDATE_ACTIVE=true; else UPDATE_ACTIVE=false; fi
	UpTimeSec=$(awk '{print $1}' /proc/uptime)
	UpTimeSec=${UpTimeSec%.*}
	LogfileAgeSec=`expr $(date +%s) - $(stat -c '%Y' "${const_LOGFILE}")`
	ApacheLogfileAgeSec=`expr $(date +%s) - $(stat -c '%Y' "${APACHE_ACCESS_LOGFILE}")`

	echo "UPDATE_ACTIVE=$UPDATE_ACTIVE"
	echo "IDLE_SEC_to_POWER_OFF=$IDLE_SEC_to_POWER_OFF"
	echo "UpTimeSec=$UpTimeSec"
	echo "LogfileAgeSec=$LogfileAgeSec"
	echo "ApacheLogfileAgeSec=$ApacheLogfileAgeSec"

	if [ $UPDATE_ACTIVE = false ] && [ "$UpTimeSec" -ge "$IDLE_SEC_to_POWER_OFF" ] && [ "$LogfileAgeSec" -ge "$IDLE_SEC_to_POWER_OFF" ] && [ "$ApacheLogfileAgeSec" -ge "$IDLE_SEC_to_POWER_OFF" ]; then
		source "${WORKING_DIR}/poweroff.sh" "poweroff" "force" "$(l 'box_poweroff_idle_time_reached')"
	fi
fi
