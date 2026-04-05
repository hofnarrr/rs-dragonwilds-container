#!/bin/bash

RSDW_APPID=4019830

STEAMCMD=/usr/games/steamcmd

if [ ${UPDATE_STEAMAPP:-1} -ne 0 ]; then
  mkdir -p ${SERVER_INSTALL_DIR}
  ${STEAMCMD} +force_install_dir ${SERVER_INSTALL_DIR} \
              +login anonymous \
              +app_update ${RSDW_APPID} \
              +quit
fi

exec "${SERVER_INSTALL_DIR}/RSDragonwildsServer.sh" -log -NewConsole $@
