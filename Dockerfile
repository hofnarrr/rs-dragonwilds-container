FROM debian:13-slim

ENV USERNAME=rsdw
ENV HOMEDIR=/opt/rsdw
ENV SERVER_INSTALL_DIR=$HOMEDIR/server

COPY files/debian-contrib-non-free.sources /etc/apt/sources.list.d/debian-contrib-non-free.sources

RUN export DEBIAN_FRONTEND=noninteractive && \
    dpkg --add-architecture i386 && \
    echo 'steamcmd steam/question string I AGREE' | debconf-set-selections && \
    apt-get update -y && \
    apt-get install -y steamcmd && \
    apt-get install -y --reinstall ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    useradd -Md $HOMEDIR $USERNAME && \
    mkdir $HOMEDIR && \
    chown -R $USERNAME:$USERNAME $HOMEDIR

COPY files/entrypoint.sh /entrypoint.sh

USER $USERNAME
WORKDIR $SERVER_INSTALL_DIR

ENTRYPOINT [ "/entrypoint.sh" ]
