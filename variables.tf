variable "location" {
  description = "The location where resources will be deployed."
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Name of the project."
  type        = string
  default     = "baseline"
}

variable "vnet_cidr" {
  description = "CIDR block range of the vnet."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block range of the subnet for the vnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "ssh_public_key_path" {
  description = "Local file path to the SSH public key used for VM authentication."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "nat_gateway_sku" {
  description = "SKU for the NAT Gateway."
  type        = string
  default     = "Standard"
}

variable "pub_ip_sku" {
  description = "SKU for the public IP."
  type        = string
  default     = "Standard"
}

variable "frontend_port" {
  description = "Port number for the frontend."
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Port number for the backend."
  type        = number
  default     = 8080

}