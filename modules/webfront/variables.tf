variable "resource_group_name" {
  description = "Resource group for the public web-front components."
  type        = string
}

variable "location" {
  description = "Azure region for the web-front components."
  type        = string
}

variable "waf_subnet_id" {
  description = "Dedicated subnet ID for Application Gateway WAF."
  type        = string
}

variable "tags" {
  description = "Common NorthStar resource tags."
  type        = map(string)
}
variable "web_subnet_id" {
  description = "Private subnet ID for the web workload."
  type        = string
}

variable "admin_ssh_public_key" {
  description = "SSH public key used for the private web server."
  type        = string
}
