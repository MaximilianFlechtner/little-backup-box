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

WORKING_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CONFIG="${WORKING_DIR}/config.cfg"
source "$CONFIG"

# Load Log library
. "${WORKING_DIR}/lib-log.sh"

# Load Mail library
. "${WORKING_DIR}/lib-mail.sh"

# Load LCD library
. "${WORKING_DIR}/lib-lcd.sh"

ping -c1 google.com &>/dev/null
while [ $? != 0 ]; do
    sleep 10
    ping -c1 google.com &>/dev/null
done

IP=$(hostname -I | cut -d' ' -f1)

if [ $DISP = true ]; then
    lcd_message "$IP"
fi

if [ ! -z $SMTP_SERVER ]; then
    TEXT_PLAIN="
web UI: http://${IP}:8000
Upload: http://${IP}:8000/upload.php
Files: http://${IP}:8080
miniDLNA: http://${IP}:8200"
    TEXT_HTML="
web UI: <a href='http://${IP}:8000'>http://${IP}:8000</a><br>
Upload: <a href='http://${IP}:8000/upload.php'>http://${IP}:8000/upload.php</a><br>
Files: <a href='http://${IP}:8080'>http://${IP}:8080</a><br>
miniDLNA: <a href='http://${IP}:8200'>http://${IP}:8200</a><br>"

    if [ -f "${WORKING_DIR}/../../mejiro/index.php" ]; then
        TEXT_PLAIN="${TEXT_PLAIN}
Mejiro: http://${IP}:8081"
        TEXT_HTML="${TEXT_HTML}
Mejiro: <a href='http://${IP}:8081'>http://${IP}:8081</a><br>"
    fi

    TEXT_PLAIN="${TEXT_PLAIN}

Samba: open 'smb://${IP}' into a file manager"

    TEXT_HTML="${TEXT_HTML}
<br>
Samba: open '<a href='smb://${IP}'>smb://${IP}</a>' into a file manager<br>"

    send_email "Little Backup Box Info: ${IP}" "${TEXT_PLAIN}" "${TEXT_HTML}"
fi
