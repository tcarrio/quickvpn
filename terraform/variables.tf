variable "vultr_api_key" {
  type = string

  validation {
    condition     = length(var.vultr_api_key) == 36
    error_message = "Must be a 36 character long API token."
  }
}

variable "region" {
  type = string
  default = "ewr"
}