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
