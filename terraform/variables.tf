variable "vultr_api_key" {
  type = string

  validation {
    condition     = length(var.vultr_api_key) == 36
    error_message = "Must be a 36 character long API token."
  }
}

variable "vultr_plan" {
  type = string
  default = "vc2-1c-1gb"
}

variable "vultr_region" {
  type = string
  default = "ewr"
}

variable "wg_local_ip" {
  type = string
  default = ""
}

variable "wg_public_key_path" {
  type = string

  validation {
    condition = fileexists(var.wg_public_key_path)
    error_message = "Must provide a public key file path"
  }
}

variable "wg_private_key_path" {
  type = string

  validation {
    condition = fileexists(var.wg_private_key_path)
    error_message = "Must provide a private key file path"
  }
}