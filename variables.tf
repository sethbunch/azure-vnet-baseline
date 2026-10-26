variable "location" {
  description = "Azure region everything deploys to."
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Name stuck onto every resource, with per-type prefixes (rg-, vnet-, snet-, and so on)."
  type        = string
  default     = "baseline"
}

variable "vnet_cidr" {
  description = "Address space for the vnet."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "App subnet range. Has to fit inside vnet_cidr."
  type        = string
  default     = "10.0.1.0/24"
}

variable "ssh_public_key_path" {
  description = "SSH key for the Phase 4 VMSS instances. Nothing in phases 1-3 uses this yet."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "nat_gateway_sku" {
  description = "NAT gateway SKU. Standard is the only one Azure supports."
  type        = string
  default     = "Standard"
}

variable "pub_ip_sku" {
  description = "SKU for the public IPs and the load balancer. Needs to be Standard for the NAT gateway setup to work."
  type        = string
  default     = "Standard"
}

variable "frontend_port" {
  description = "Port clients hit the load balancer on."
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Port the app listens on. The LB rule sends traffic here and the probe asks for /health on it."
  type        = number
  default     = 8080
}
