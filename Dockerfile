FROM shcoder/alpine-consul

MAINTAINER sameer@damagehead.com
MAINTAINER shcoder.alex@gmail.com

ENV WOWZA_VERSION=4.5.0 \
    WOWZA_USER_NAME=admin \
    WOWZA_USER_PASSWORD=admin \
    WOWZA_PUBLISH_USER_NAME=admin \
    WOWZA_PUBLISH_USER_PASSWORD=admin \
    WOWZA_LICENSE=ET2A4-ntGJH-vjEM3-YbQY4-d6T9V-BVvVF-7mZxjdWappY1  \
    WOWZA_ROLE=origin \
    WOWZA_LB_KEY=123456789 \
    WOWZA_LB_IP=127.0.0.1 \
    WOWZA_LB_PORT=1935 \
    WOWZA_ORIGIN_IP=127.0.0.1 \
    WOWZA_ORIGIN_IP_ADDRESSES=127.0.0.1 \
    CONSUL_SERVICE_NAME=wowza 

ADD WowzaStreamingEngine/conf /tmp/conf
ADD WowzaStreamingEngine/lib /tmp/lib
ADD WowzaStreamingEngine/transcoder /tmp/transcoder
ADD templates /tmp/templates

ADD prepare.sh /tmp/
ADD bin/consul-template/start.sh /opt/consul-template/
ADD bin/wowza/start.sh /opt/wowza/
ADD entrypoint.sh /sbin/
ADD consul/wowza.json /etc/consul.d/

RUN chmod 755 /sbin/entrypoint.sh \
	  /opt/consul/start.sh \
	  /opt/consul-template/start.sh \
	  /opt/wowza/start.sh && \
	  /tmp/prepare.sh

WORKDIR /usr/local/WowzaStreamingEngine

EXPOSE 1935/tcp 8086/tcp 8087/tcp 8088/tcp 9777/udp

CMD ["/sbin/entrypoint.sh"]