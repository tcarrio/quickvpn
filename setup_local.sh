#!/usr/bin/env bash

local_ip=$(ip a | grep -I '^[0-9]: en' -A 3 | grep inet | awk '{print $2}' | cut -d '/' -f 1)
server_ip=$(make tf_output ARGS="-raw server_ip")
private_key="$(cat wg_key)"
public_key="$(cat wg_key.pub)"

cat << EOF > wg_local.conf
[Interface]
Address = 10.200.200.2/32
PrivateKey = $private_key 
DNS = $server_ip

[Peer]
PublicKey = $public_key
Endpoint = $server_ip:51820
AllowedIPs = 0.0.0.0/0, ::/0
EOF
