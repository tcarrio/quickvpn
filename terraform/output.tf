output "server_ip" {
  value = vultr_instance.vpn.main_ip
}

output "password" {
  value = vultr_instance.vpn.default_password
  sensitive = true
}