resource "vultr_instance" "vpn" {
  plan = "vc2-1c-1gb"
  region = var.region
  os_id = 535 # Btw I run Arch
}