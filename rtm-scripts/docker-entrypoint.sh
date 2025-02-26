#!/bin/bash

MORIA_DIR="/home/steam/moriaserver"

# Quick function to generate a timestamp
timestamp () {
  date +"%Y-%m-%d %H:%M:%S,%3N"
}

shutdown () {
    echo ""
    echo "$(timestamp) INFO: Recieved SIGTERM, shutting down gracefully"
    kill -2 $rtm_pid
}

# Set our trap
trap 'shutdown' TERM


# Download/Update Return To Moria Server Files
echo "$(timestamp) INFO: Updating Return To Moria Dedicated Server"
/home/steam/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /home/steam/moriaserver +login Anonymous +app_update 3349480 +quit

# Check that steamcmd was successful
if [ $? != 0 ]; then
    echo "ERROR: steamcmd was unable to successfully initialize and update Moria..."
    exit 1
fi

# Create Server Config
source /home/steam/createserverconfig.sh

# Create Server Permissions
source /home/steam/createserverpermissions.sh

# Create Server Rules
if [ -v SERVERRULES ]; then
    echo ${SERVERRULES} >> ${MORIA_PATH}/MoriaServerRules.txt
else
    touch ${MORIA_PATH}/MoriaServerRules.txt
fi

# Wine talks too much and it's annoying
export WINEDEBUG=-all

echo "Starting fake screen"
rm -f /tmp/.X0-lock 2>&1
Xvfb :0 -screen 0 1024x768x24 -nolisten tcp &

#Launch Return To Moria Dedicated Server
DISPLAY=:0.0 wine64 /home/steam/moriaserver/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.exe &

# Find pid for MoriaServer.exe
timeout=0
while [ $timeout -lt 11 ]; do
    if ps -e | grep "MoriaServer"; then
        rtm_pid=$(ps -e | grep "MoriaServer" | awk '{print $1}')
        break
    elif [ $timeout -eq 10 ]; then
        echo "$(timestamp) ERROR: Timed out waiting for MoriaServer.exe to be running"
        exit 1
    fi
    sleep 6
    ((timeout++))
    echo "$(timestamp) INFO: Waiting for MoriaServer.exe to be running"
done

# Hold us open until we recieve a SIGTERM
wait

# Handle post SIGTERM from here
# Hold us open until WSServer-Linux pid closes, indicating full shutdown, then go home
tail --pid=$rtm_pid -f /dev/null

# o7
echo "$(timestamp) INFO: Shutdown complete."
exit 0
