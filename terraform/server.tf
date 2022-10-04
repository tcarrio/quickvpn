data "local_sensitive_file" "wg_private_key" {
  filename = var.wg_private_key_path
}

data "local_file" "wg_public_key" {
  filename = var.wg_public_key_path
}

locals {
  # the config file for wireguard
  wg_config = <<EOT
[Interface]
Address = 10.200.200.1
PrivateKey = ${trimspace(data.local_sensitive_file.wg_private_key.content)}
ListenPort = 51820

# TODO: Conditionally allow forwarding traffic to local network on the eno1? interface.
# PostUp   = iptables -A FORWARD -i eno1 -j ACCEPT; iptables -A FORWARD -o eno1 -j ACCEPT; iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
# PostDown = iptables -D FORWARD -i eno1 -j ACCEPT; iptables -D FORWARD -o eno1 -j ACCEPT; iptables -t nat -D POSTROUTING -o eno1 -j MASQUERADE

[Peer]
PublicKey = ${trimspace(data.local_file.wg_public_key.content)}
%{if var.wg_local_ip != "" }AllowedIPs = ${var.wg_local_ip}%{endif}
EOT

  # setup script for the instance
  setup_script = <<EOT
# create Wireguard configuration directory
mkdir -p /etc/wireguard

# configure IPv4 forwarding
sysctl -w net.ipv4.ip_forward=1

# configure the firewall
# TODO

# configure Wireguard
cat << EOF > /etc/wireguard/wg0.conf
${local.wg_config}
EOF

EOT
}

resource "vultr_startup_script" "vpn_init" {
  name = "Initialize Wireguard server"
  script = base64encode(local.setup_script)
}

resource "vultr_instance" "vpn" {
  plan = var.vultr_plan
  region = var.vultr_region
  os_id = 535 # Btw I run Arch
  script_id = vultr_startup_script.vpn_init.id
}

