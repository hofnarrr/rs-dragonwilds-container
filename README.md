# RuneScape: Dragonwilds Docker image

### build it.

    $ docker build -f Dockerfile -t rs-dragonwilds:latest

### run it.

Run the image like you'd run the regular server exe.

Command line flags `-log` and `-NewConsole` are always used. Rest of
the arguments, if provided, are passed to the server executable.

    $ docker run -it rs-dragonwilds:latest

    $ docker run -it rs-dragonwilds:latest -Port=1337

#### steamapp installation and updates

By default the image runs `steamcmd` to install or update the dedicated server
before launching it. This can be disabled by setting the environment variable
`UPDATE_STEAMAPP` value to `0`.

    $ docker run -it -e UPDATE_STEAMAPP=0 rs-dragonwilds:latest

### configuration and savegames.

This image doesn't manage configuration - users should use their preferred
methods to manage the configs, and mount them into the container, e.g.:

    $ docker run -it \
        -v ./DedicatedServer.ini:/opt/rsdw/server/RSDragonwilds/Saved/Config/LinuxServer/DedicatedServer.ini \
        rs-dragonwilds:latest

Savegames should be supplied using the same method.

It is also advised to mount a volume to the server installation directory path
to persist the game files over container reboots and avoid redownloading them 
on every start.
