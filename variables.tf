variable "resource_group_name" {
  description = "Name of the NorthStar landing zone resource group."
  type        = string
  default     = "NorthStar-Landing-Zone-RG"
}

variable "location" {
  description = "Azure deployment region."
  type        = string
  default     = "canadacentral"
}

variable "tags" {
  description = "Standard tags applied to NorthStar resources."
  type        = map(string)

  default = {
    Project     = "NorthStar"
    Environment = "Portfolio"
    ManagedBy   = "Terraform"
    Owner       = "Guy Diangana"
    CostControl = "CA$10-monthly-budget"
  }
}
variable "admin_ssh_public_key" {
  description = "SSH public key for the private NorthStar web server."
  type        = string
}
