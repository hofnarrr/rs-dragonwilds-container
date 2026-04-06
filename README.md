# RuneScape: Dragonwilds Docker image

## build it.

    $ git clone https://github.com/hofnarrr/rs-dragonwilds-container
    $ cd rs-dragonwilds-container/

    $ docker build -f Dockerfile -t rs-dragonwilds:latest

## run it.

Run the image like you'd run the regular server exe.

Command line flags `-log` and `-NewConsole` are always used. Rest of
the arguments, if provided, are passed to the server executable.

    $ docker run rs-dragonwilds:latest

    $ docker run rs-dragonwilds:latest -Port=1337

It is advised to mount a volume onto the server installation directory path
to persist the game files over container reboots and to avoid redownloading them 
on every start.

    $ docker volume create rsdw-server

    $ docker run \
        -v rsdw-server:/opt/rsdw/server:rw \
        rs-dragonwilds:latest

See also [`examples/docker-compose.yml`](examples/docker-compose.yml) for
a small Composefile example.

### installation and updates.

By default the image runs `steamcmd` to install or update the dedicated server
before launching it. This can be disabled by setting the environment variable
`RSDW_UPDATE_SERVER` value to `0`.

    $ docker run -e RSDW_UPDATE_SERVER=0 rs-dragonwilds:latest

### configuration and savegames.

Configuration files (`DedicatedServer.ini`) and savegames may be supplied by
mounting them into the container under `/config` and `/savegames` respectively.

Entrypoint script copies all `.ini`/`.sav` files from above directories to
the RS:DW install dir before starting the server process - on every startup.

    $ docker run \
        -v ./cfg/:/config:ro \
        -v ./saves/:/savegames:ro \
        -v rsdw-server:/opt/rsdw/server:rw \
        rs-dragonwilds:latest

Some care must be taken as RS:DW may in some cases modify `DedicatedServer.ini`
(and obviously savegames as well). E.g. during the first start a server GUID is
generated and added to the config file - mounted config should be updated
accordingly.
