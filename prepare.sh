#!/bin/bash
set -e

WOWZA_INSTALLER_URL="https://www.wowza.com/downloads/WowzaStreamingEngine-${WOWZA_VERSION//./-}/WowzaStreamingEngine-${WOWZA_VERSION}-linux-x64-installer.run"
WOWZA_INSTALLER_FILE="WowzaStreamingEngine.run"


cd /tmp/

wget "${WOWZA_INSTALLER_URL}" -O "${WOWZA_INSTALLER_FILE}"
chmod +x "${WOWZA_INSTALLER_FILE}"

cat > /etc/supervisor.d/wowza.ini <<EOF
[program:wowza]
priority=10
directory=/usr/local/WowzaStreamingEngine/bin
command=/bin/bash /opt/wowza/start.sh
user=root
autostart=true
autorestart=true
stopasgroup=true
stopsignal=KILL
stdout_logfile=/var/log/supervisor/%(program_name)s.log
stderr_logfile=/var/log/supervisor/%(program_name)s.log
EOF

cat > /etc/supervisor.d/wowzamgr.ini <<EOF
[program:wowzamgr]
priority=20
directory=/usr/local/WowzaStreamingEngine/manager/bin
command=/usr/local/WowzaStreamingEngine/manager/bin/startmgr.sh
user=root
autostart=true
autorestart=true
stopasgroup=true
stopsignal=KILL
stdout_logfile=/var/log/supervisor/%(program_name)s.log
stderr_logfile=/var/log/supervisor/%(program_name)s.log
EOF

cat > /etc/supervisor.d/consul-template.ini <<EOF
[program:consul-template]
priority=10
command=/bin/bash /opt/consul-template/start.sh
user=root
autostart=true
autorestart=true
stopasgroup=true
stopsignal=KILL
stdout_logfile=/var/log/supervisor/%(program_name)s.log
stderr_logfile=/var/log/supervisor/%(program_name)s.log
EOF

#Install wowza without license
mkdir /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/scripts/ -p 

echo "#!/bin/bash" > /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/scripts/validateInstall-linux.sh 
echo "exit 0;" >> /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/scripts/validateInstall-linux.sh 

echo "#!/bin/bash" > /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/scripts/validatelicense-linux.sh 
echo "exit 0;" >> /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/scripts/validatelicense-linux.sh 

chmod +x /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/scripts/validatelicense-linux.sh /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/scripts/validateInstall-linux.sh 
./WowzaStreamingEngine.run --mode unattended --licensekey ${WOWZA_LICENSE} --username ${WOWZA_USER_NAME} --password ${WOWZA_USER_PASSWORD} --prefix .

rm WowzaStreamingEngine.run