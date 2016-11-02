#!/bin/bash

WOWZA_PID_FILE=/var/run/WowzaStreamingEngine.pid
WOWZA_CMD=/usr/bin/WowzaStreamingEngined
WOWZA_CONFIG_SCRIPT="/usr/local/WowzaStreamingEngine/bin/setenv.sh"

function shutdown()
{
	echo "WTF $pid" > /tmp/log.log
	read pid < $WOWZA_PID_FILE
	kill -9 $pid
	rm $WOWZA_PID_FILE
}

trap shutdown HUP INT QUIT ABRT KILL ALRM TERM TSTP
exec $WOWZA_CMD $WOWZA_CONFIG_SCRIPT $WOWZA_PID_FILE start &

pid=$!
wait $pid