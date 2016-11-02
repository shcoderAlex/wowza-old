#!/bin/bash

echo "${WOWZA_USER_NAME} ${WOWZA_USER_PASSWORD} admin|advUser" > /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/conf/admin.password
echo "${WOWZA_PUBLISH_USER_NAME} ${WOWZA_PUBLISH_USER_PASSWORD}" > /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/conf/publish.password
echo ${WOWZA_LICENSE} > /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/conf/Server.license

sed -i "s/{{CONSUL_SERVICE_NAME}}/${CONSUL_SERVICE_NAME}/g" /etc/consul.d/wowza.json

if [ ! -z "${CONSUL_SERVICE_TAGS}" ]; then
  TAGS=""

  for tag in $(echo ${CONSUL_SERVICE_TAGS} | sed -e 's/,/ /g');do
    TAGS="${TAGS} ${tag}"
  done

  TAGS=$(echo ${TAGS}|sed -e 's/ /\",\"/g')
  sed -i -e "s#\"tags\":.*#\"tags\": [\"${TAGS}\"],#" /etc/consul.d/wowza.json
fi

sed -i "s/{{WOWZA_LB_KEY}}/${WOWZA_LB_KEY}/g" /tmp/conf/${WOWZA_ROLE}/Server.xml
sed -i "s/{{WOWZA_LB_IP}}/${WOWZA_LB_IP}/g" /tmp/conf/${WOWZA_ROLE}/Server.xml
sed -i "s/{{WOWZA_LB_PORT}}/${WOWZA_LB_PORT}/g" /tmp/conf/${WOWZA_ROLE}/Server.xml

sed -i "s/{{WOWZA_ORIGIN_IP}}/${WOWZA_ORIGIN_IP}/g" /tmp/conf/${WOWZA_ROLE}/Server.xml
sed -i "s/{{WOWZA_ORIGIN_IP_ADDRESSES}}/${WOWZA_ORIGIN_IP_ADDRESSES}/g" /tmp/conf/${WOWZA_ROLE}/live/Application.xml

sed -i "s/{{WOWZA_S3_SECRET_KEY}}/${WOWZA_S3_SECRET_KEY}/g" /tmp/conf/${WOWZA_ROLE}/live/Application.xml
sed -i "s/{{WOWZA_S3_ACCESS_KEY}}/${WOWZA_S3_ACCESS_KEY}/g" /tmp/conf/${WOWZA_ROLE}/live/Application.xml
sed -i "s/{{WOWZA_S3_BUCKET_NAME}}/${WOWZA_S3_BUCKET_NAME}/g" /tmp/conf/${WOWZA_ROLE}/live/Application.xml

if [ ${WOWZA_ROLE} = "tester" ]; then
	rm /etc/supervisor.d/wowzamgr.ini
fi

cp /tmp/conf/${WOWZA_ROLE}/* /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/conf -R
cp /tmp/transcoder/* /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/transcoder -R
cp /tmp/lib/* /usr/local/WowzaStreamingEngine-${WOWZA_VERSION}/lib

if [[ -z ${1} ]]; then
  exec /usr/bin/supervisord -n -c /etc/supervisor.d/supervisord.conf
else
  exec "$@"
fi