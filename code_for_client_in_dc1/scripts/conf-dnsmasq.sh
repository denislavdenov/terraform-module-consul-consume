#!/usr/bin/env bash
sleep 5
apt-get install dnsmasq -y
cat << EOF > /etc/dnsmasq.d/10-consul
server=/consul/127.0.0.1#8600
EOF

sed -i -e 's/#resolv-file=/resolv-file=\/etc\/dnsmasq.d\/outside.conf/g' /etc/dnsmasq.conf
cat << EOF > /etc/dnsmasq.d/outside.conf
server=8.8.8.8
EOF

systemctl restart dnsmasq.service
