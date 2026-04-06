FROM debian:13-slim

ENV USERNAME=rsdw
ENV HOMEDIR=/opt/rsdw
ENV RSDW_INSTALL_DIR=$HOMEDIR/server

COPY files/debian-contrib-non-free.sources /etc/apt/sources.list.d/debian-contrib-non-free.sources

RUN export DEBIAN_FRONTEND=noninteractive && \
    dpkg --add-architecture i386 && \
    echo 'steamcmd steam/question string I AGREE' | debconf-set-selections && \
    apt-get update -y && \
    apt-get install -y steamcmd && \
    apt-get install -y --reinstall locales ca-certificates && \
    echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    useradd -Md $HOMEDIR $USERNAME && \
    mkdir $HOMEDIR && \
    chown -R $USERNAME:$USERNAME $HOMEDIR

COPY files/entrypoint.sh /entrypoint.sh

USER $USERNAME
WORKDIR $RSDW_INSTALL_DIR
VOLUME [ "$RSDW_INSTALL_DIR" ]

ENTRYPOINT [ "/entrypoint.sh" ]
