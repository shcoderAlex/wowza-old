#!/bin/bash

if [ ${WOWZA_ROLE} = "edge" ]; then
	CTMPL_PATH=/tmp/templates/${WOWZA_ROLE}/live/Application.xml.ctmpl
	CONF_PATH=/usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/conf/live/Application.xml
	CMD_RESTART_WOWZA="supervisorctl -c /etc/supervisor.d/supervisord.conf restart wowza"
	consul-template -consul localhost:8500 -template "${CTMPL_PATH}:${CONF_PATH}:${CMD_RESTART_WOWZA}"
fi

if [ ${WOWZA_ROLE} = "origin" ]; then
	CTMPL_PATH=/tmp/templates/${WOWZA_ROLE}/Server.xml.ctmpl
	CONF_PATH=/usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/conf/Server.xml
	CMD_RESTART_WOWZA="supervisorctl -c /etc/supervisor.d/supervisord.conf restart wowza"
	consul-template -consul localhost:8500 -template "${CTMPL_PATH}:${CONF_PATH}:${CMD_RESTART_WOWZA}"
fi