
MORIA_DIR="/home/steam/moriaserver"
MORIA_INI="${MORIA_PATH}/MoriaServerConfig.ini"

SERVERPASS="${SERVERPASS:-}"
SERVERNAME="${SERVERNAME:-Dedicated Server World}"
OPTIONALSERVERSAVEFILENAME="${OPTIONALSERVERSAVEFILENAME:-}"
SERVERTYPE="${SERVERTYPE:-campaign}"
SERVERSEED="${SERVERSEED:-random}"
SERVERDIFFICULTY="${SERVERDIFFICULTY:-normal}"
CUSTOMDIFFICULTYCOMBAT="default"
CUSTOMDIFFICULTYAGGRESSION="high"
CUSTOMDIFFICULTYSURVIVAL="default"
CUSTOMDIFFICULTYMINING="default"
CUSTOMDIFFICULTYWORLD="default"
CUSTOMDIFFICULTYHORDE="default"
CUSTOMDIFFICULTYSIEGE="default"
CUSTOMDIFFICULTYPATROL="default"
SERVERIP="${SERVERIP:-}"
SERVERPORT="${SERVERPORT:-7777}"
SERVERADVERTISEIP="${SERVERADVERTISEIP:-auto}"
SERVERADVERTISEPORT="${SERVERADVERTISEPORT:-}"
INITCONNECTIONRETRYTIME="${INITCONNECTIONRETRYTIME:-120}"
DISCONNECTRETRYTIME="${DISCONNECTRETRYTIME:-600}"
SERVERCONSOLE="${SERVERCONSOLE:-true}"
SERVERFPS="${SERVERFPS:-60}"
SERVERAREALIMIT="${SERVERAREALIMIT:-12}"

if [ -f $MORIA_INI ]; then
    echo "Server Config file already exists. Deleting to recreate."
    rm -fr $MORIA_INI
fi

touch ${MORIA_INI}

echo "Writing server config file to: ${MORIA_INI}"
echo "; Configuration file for the dedicated server.
; Only edit this configuration when the server is offline.
; This list may be overwritten when changes are made in-game.


[Main]
; If a password is specified, players will need to enter a password to join the server.
; Case-sensitive.
OptionalPassword=${SERVERPASS}


[World]
; Name of the saved world to load. If it doesn't exist, create it
; with the properties defined in the [World.Create] section.
Name=\"${SERVERNAME}\"

; The file name of the world to load. Helpful if you have multiple worlds with the same name.
; Note that renaming world files is not currently supported.
OptionalWorldFilename=${OPTIONALSERVERSAVEFILENAME}


[World.Create]
; World generation parameters, only for newly created worlds.

; Type of world to create:
;  * campaign
;  * sandbox
Type=${SERVERTYPE}

; Seed for world generation:
;  * random - Generates a random seed.
;  * <integer> - Use the given number.
Seed=${SERVERSEED}

; Specify world difficulty:
;  * story: Ideal for players who want to experience the story without much danger.
;  * solo: Ideal for a single dwarf.
;  * normal: Ideal for a small company of dwarves.
;  * hard: Ideal for a large company of dwarves.
;  * custom: Use customizations for each category of difficulty.
Difficulty.Preset=${SERVERDIFFICULTY}

; Custom difficulty properties, used only if the "Difficulty.Preset" property is set to custom.
; Acceptable values are verylow, low, default, high and veryhigh.
; The base enemy damage and hit points.
Difficulty.Custom.CombatDifficulty=default
; How often enemies attack and how many will attack at once.
Difficulty.Custom.EnemyAggression=high
; The strength of various buffs, speed a dwarf succumbs to despair and
; the decay rates of stamina, energy and hunger.
Difficulty.Custom.SurvivalDifficulty=default
; Volume of ore that drops from each vein.
Difficulty.Custom.MiningDrops=default
; The drop rates of rewards for defeating orcs and enemies.
Difficulty.Custom.WorldDrops=default
; How often noisy actions will trigger a horde of orcs.
Difficulty.Custom.HordeFrequency=default
; How often orcs will target and attack a dwarf base.
Difficulty.Custom.SiegeFrequency=default
; How often orc and enemy groups spawn.
Difficulty.Custom.PatrolFrequency=default


[Host]

; Local IP address to bind on the server.
; Normally leave this empty.
; Possible values:
; * Empty value for default (bind all adapters.)
; * <IPv4> or <IPv6> ... manually specify the IP address.
ListenAddress=${SERVERIP}

; Port bound by the server for incoming connections.
; You must allow TCP and UDP traffic on your firewall and may need to set up port forwarding.
; Possible values:
;  * -1 ... use the default engine port (7777)
;  * <integer> ... manually specify the port.
ListenPort=${SERVERPORT}

; Host reported to clients. Clients will try to connect it when joining a hosted session.
; Normally set this to "auto".
; If this machine and all of your friends are playing on a LAN, set this to "local" to avoid having to set up port forwarding.
; If there is an issue with automatic detection, you can specify your server's IP address directly.
; Possible values:
;  * auto ... detect public IP address. For public servers or servers behind NAT, proxy,
;             or in a container with properly configured port mapping or port forwarding.
;  * local ... automatically detect local IP address. For LAN games and servers with a public IP address.
;  * <IPv4> or <IPv6> ... manually specify the IP address clients should connect to.
AdvertiseAddress=${SERVERADVERTISEIP}

; Port reported to clients. Clients will try to connect it when joining a hosted session.
; Normally leave this empty.
; Possible values:
;  * <empty> ... use the ListenPort. To be used when connecting directly or via port forwarding.
;  * <integer> ... manually specify the port. To be used when the server
;                  listen port is mapped to a different, exposed port. This is rare.
AdvertisePort=${SERVERADVERTISEPORT}

; If you fail to host on launch, the maximum number of seconds to retry.
InitialConnectionRetryTime=${INITCONNECTIONRETRYTIME}

; If your hosted session drops, the maximum number of seconds to try to rehost.
AfterDisconnectionRetryTime=${DISCONNECTRETRYTIME}


[Console]
; Open the console window so you can type commands. (true or false)
; Note: To close the app, you will need to kill the process in Windows Task Manager.
Enabled=${SERVERCONSOLE}


[Performance]
; Frames per second to tick the server.
; Typically leave this at 60. Higher values are unlikely to improve a dedicated server.
; If your server uses too much CPU, you might try 30 fps instead.
ServerFPS=${SERVERFPS}
; Maximum number of areas to keep loaded at once, a number between 4 and 32.
; This number greatly impacts memory, CPU usage and bandwidth.
; The default is 12 loaded areas, which generally supports 8 player sessions well.
; If you wish to improve performance, reducing to 8 loaded areas supports 4 player sessions very well.
; Increasing this number above 12 may decrease the number of loading walls you see,
; at the cost of much higher memory and CPU usage, as more enemies will need to be simulated to fill those areas.
LoadedAreaLimit=${SERVERAREALIMIT}" >> ${MORIA_INI}

