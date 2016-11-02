#Wowza

### ENV
* **WOWZA_USER_NAME**
* **WOWZA_USER_PASSWORD**
* **WOWZA_PUBLISH_USER_NAME**
* **WOWZA_PUBLISH_USER_PASSWORD**
* **WOWZA_LICENSE**
* **WOWZA_ROLE**
* **WOWZA_ORIGIN_IP**
* **WOWZA_ORIGIN_IP_ADDRESSES**
* **CONSUL_SERVICE_NAME**
* **CONSUL_SERVICE_TAGS**

### Example

### Wowza LB
docker run -d --name wowza-lb -p 3935:1935 -p 8086:8088 --net consul_default \
  -e WOWZA_USER_NAME=admin \
  -e WOWZA_USER_PASSWORD=admin \
  -e WOWZA_LICENSE=ET2A4-ntGJH-vjEM3-YbQY4-d6T9V-BVvVF-7mZxjdWappYK \
  -e WOWZA_ROLE=lb \
  -e CONSUL_CLUSTER_IPS=node-1 \
  -e CONSUL_ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \
shcoder/wowza 

### Wowza Origin
docker run -d --name wowza-origin -p 8088:8088 -p 3936:1935 \
  -e WOWZA_USER_NAME=admin \
  -e WOWZA_USER_PASSWORD=admin \
  -e WOWZA_LICENSE=ET2A4-ntGJH-vjEM3-YbQY4-d6T9V-BVvVF-7mZxjdWappYK \
  -e WOWZA_ORIGIN_IP=wowza-origin \
  -e WOWZA_ROLE=origin \
shcoder/wowza 

### Wowza Edge
docker run -d --name wowza-edge -p 3937:1935 -p 8087:8088 \
  -e WOWZA_USER_NAME=admin \
  -e WOWZA_USER_PASSWORD=admin \
  -e WOWZA_LICENSE=ET2A4-ntGJH-vjEM3-YbQY4-d6T9V-BVvVF-7mZxjdWappYK \
  -e WOWZA_ROLE=edge \
  -e WOWZA_ORIGIN_IP_ADDRESSES=wowza-origin \
shcoder/wowza 

--------------------------------------------------------------------------------------

### Wowza Origin
docker service create --network consul-net --name wowza-origin -p 1935:1935 --constraint "node.labels.node==wowza-origin" --replicas=2 \
  -e WOWZA_USER_NAME=admin \
  -e WOWZA_USER_PASSWORD=admin \
  -e WOWZA_LICENSE=ET2A4-ntGJH-vjEM3-YbQY4-d6T9V-BVvVF-7mZxjdWappYK \
  -e WOWZA_ROLE=origin \
  -e CONSUL_CLUSTER_IPS=consul \
  -e CONSUL_ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \
  -e CONSUL_SERVICE_NAME=wowza-origin \
  -e CONSUL_SERVICE_TAGS=origin \
shcoder/wowza 

### Wowza Edge
docker service create --network consul-net --name wowza-edge -p 1936:1935 --constraint "node.labels.node==wowza-edge" --replicas=3 \
  -e WOWZA_USER_NAME=admin \
  -e WOWZA_USER_PASSWORD=admin \
  -e WOWZA_LICENSE=ET2A4-ntGJH-vjEM3-YbQY4-d6T9V-BVvVF-7mZxjdWappYK \
  -e WOWZA_ROLE=edge \
  -e WOWZA_ORIGIN_IP_ADDRESSES=wowza-origin \
  -e CONSUL_CLUSTER_IPS=consul \
  -e CONSUL_ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \
  -e CONSUL_SERVICE_NAME=wowza-edge \
  -e CONSUL_SERVICE_TAGS=edge \
shcoder/wowza

### Wowza LB
docker service create --network consul-net --name wowza-lb -p 1937:1935 --constraint "node.labels.node==wowza-lb" --replicas=1\
  -e WOWZA_USER_NAME=admin \
  -e WOWZA_USER_PASSWORD=admin \
  -e WOWZA_LICENSE=ET2A4-ntGJH-vjEM3-YbQY4-d6T9V-BVvVF-7mZxjdWappYK \
  -e WOWZA_ROLE=lb \
  -e CONSUL_CLUSTER_IPS=consul \
  -e CONSUL_ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \
  -e CONSUL_SERVICE_NAME=wowza-lb \
  -e CONSUL_SERVICE_TAGS=lb \
shcoder/wowza 