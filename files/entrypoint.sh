#!/bin/bash

RSDW_APPID=4019830

RSDW_INSTALL_DIR="${RSDW_INSTALL_DIR:-${HOME}/server}"

RSDW_USER_CONFIG_DIR="${RSDW_USER_CONFIG_DIR:-/config}"
RSDW_USER_SAVEGAME_DIR="${RSDW_USER_SAVEGAME_DIR:-/savegames}"

RSDW_SERVER_CONFIG_DIR="${RSDW_SERVER_CONFIG_DIR:-${RSDW_INSTALL_DIR}/RSDragonwilds/Saved/Config/LinuxServer}"
RSDW_SERVER_SAVEGAME_DIR="${RSDW_SERVER_SAVEGAME_DIR:-${RSDW_INSTALL_DIR}/RSDragonwilds/Saved/SaveGames}"

STEAMCMD=/usr/games/steamcmd

if [ "${RSDW_UPDATE_SERVER:-1}" -ne 0 ]; then
  ${STEAMCMD} +force_install_dir "${RSDW_INSTALL_DIR}" \
              +login anonymous \
              +app_update "${RSDW_APPID}" \
              +quit
fi

# bind mounting directly on top of the game server directory causes
# permission issues in some container environments.
# copying configs and saves from another directory avoids the issue.
if [[ -d "${RSDW_USER_CONFIG_DIR}" ]]; then
  echo "[!] Copying configs from ${RSDW_USER_CONFIG_DIR} to ${RSDW_SERVER_CONFIG_DIR} ..."
  find "${RSDW_USER_CONFIG_DIR}" -type f -name '*.ini' -printf '[>]   %p\n' \
    -exec cp {} "${RSDW_SERVER_CONFIG_DIR}" \;
  echo "[!] Configs copied!"
else echo "[!] ${RSDW_USER_CONFIG_DIR} doesn't exist, configs not copied."; fi

if [[ -d "${RSDW_USER_SAVEGAME_DIR}" ]]; then
  echo "[!] Copying savegames from ${RSDW_USER_SAVEGAME_DIR} to ${RSDW_SERVER_SAVEGAME_DIR} ..."
  find "${RSDW_USER_SAVEGAME_DIR}" -type f -name '*.sav' -printf '[>]   %p\n' \
    -exec cp {} "${RSDW_SERVER_SAVEGAME_DIR}" \;
  echo "[!] Savegames copied!"
else echo "[!] ${RSDW_USER_SAVEGAME_DIR} doesn't exist, savegames not copied."; fi

exec "${RSDW_INSTALL_DIR}/RSDragonwildsServer.sh" -log -NewConsole $@
