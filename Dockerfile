FROM debian:12-slim

ARG CONTAINER_GID=10000
ARG CONTAINER_UID=10000

ENV DEBIAN_FRONTEND="noninteractive" \
    MORIA_PATH="/home/steam/moriaserver" \
    WINEPREFIX="/home/steam/.moriaserver_prefix" \
    WINEARCH="win64"


###########################
#### Base System Setup ####
###########################
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        procps \
        ca-certificates \
        curl \
        wget \
        wine64 \
        lib32gcc-s1 \
        cabextract \
        winbind \
        gosu \
        psmisc \
        xvfb && \
    groupadd -g $CONTAINER_GID steam && \
    useradd -g $CONTAINER_GID -u $CONTAINER_UID -m steam &&\
    echo "XDG_RUNTIME_DIR=/run/user/10000" >> ~/.bashrc

    # Download and Install Wine
#RUN mkdir -pm755 /etc/apt/keyrings && \
#    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
#    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources && \
#    apt-get update && \
#    apt-get install -y --install-recommends winehq-stable

    # Download and Install Winetricks    
RUN wget -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x /usr/local/bin/winetricks && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean && \
    apt autoremove -y

#Download and Install Steamcmd
RUN mkdir -p /home/steam/steamcmd && \
    curl -sqL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar zxvf - -C /home/steam/steamcmd && \
    chmod +x /home/steam/steamcmd/steamcmd.sh

# Setup Directories
RUN chmod 700 /tmp && \
    chown -R steam:steam /tmp && \
    mkdir "$MORIA_PATH" && \
    chown -R steam:steam "$MORIA_PATH" && \
    mkdir "$WINEPREFIX" && \
    chown steam:steam "$WINEPREFIX" && \
    chown -R steam:steam /home/steam


USER steam

COPY rtm-scripts/* /home/steam

# Setup Wine
RUN /home/steam/winetricks.sh

WORKDIR /home/steam

COPY rtm-scripts/* /home/steam

ENTRYPOINT ["/home/steam/docker-entrypoint.sh"]