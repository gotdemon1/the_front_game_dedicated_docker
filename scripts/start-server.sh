#!/bin/bash
if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
    echo "SteamCMD not found!"
    wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz
    tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
    rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

echo "---Update SteamCMD---"
if [ "${USERNAME}" == "" ]; then
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +quit
else
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login ${USERNAME} ${PASSWRD} \
    +quit
fi

echo "---Update Server---"

if [ "${USERNAME}" == "" ]; then
    if [ "${VALIDATE}" == "true" ]; then
        echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows
        +force_install_dir ${SERVER_DIR} \
        +login anonymous \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows
        +force_install_dir ${SERVER_DIR} \
        +login anonymous \
        +app_update ${GAME_ID} \
        +quit
    fi
else
    if [ "${VALIDATE}" == "true" ]; then
        echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows
        +force_install_dir ${SERVER_DIR} \
        +login ${USERNAME} ${PASSWRD} \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows
        +force_install_dir ${SERVER_DIR} \
        +login ${USERNAME} ${PASSWRD} \
        +app_update ${GAME_ID} \
        +quit
    fi
fi


echo "---Start Server---"
cd ${SERVER_DIR}
echo "Listen?MaxPlayers=$MAXPLAYERS -server -game -QueueThreshold=8 -ServerName=$SERVER_NAME -ServerPassword=$SERVER_PASS -ServerAdminAccounts=$SERVER_ADMIN -log log=log.log -locallogtimes -DedicatedServer -EnableParallelCharacterTickFunction -UseDynamicPhysicsScene -OutIPAddress=$PUBLIC_IP -ServerID=1b5cf939-657e-4c7f-a954-4a296768b4fd -port=$GAME_PORT -BeaconPort=$BEACON_PORT -QueryPort=$QUERY_PORT -Game.PhysicsVehicle=true -ansimalloc -Game.MaxFrameRate=$MAX_FRAME -ShutDownServicePort=$DOWN_PORT";

./ProjectWar/Binaries/Linux/TheFrontServer ProjectWar_Start?DedicatedServer?MaxPlayers=$MAXPLAYERS -server -game -QueueThreshold=8 -ServerName="$SERVER_NAME" -ServerPassword=$SERVER_PASS -ServerAdminAccounts=$SERVER_ADMIN -log log=log.log -locallogtimes -EnableParallelCharacterMovementTickFunction -EnableParallelCharacterTickFunction -UseDynamicPhysicsScene -OutIPAddress=$PUBLIC_IP -ServerID=1b5cf939-657e-4c7f-a954-4a296768b4fd -port=$GAME_PORT -BeaconPort=$BEACON_PORT -QueryPort=$QUERY_PORT -Game.PhysicsVehicle=true -ansimalloc -Game.MaxFrameRate=$MAX_FRAME -ShutDownServicePort=$DOWN_PORT