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

variable "cloud_admins_group_object_id" {
  description = "Microsoft Entra object ID for the Cloud Admins group. Supply securely at deployment time."
  type        = string
  sensitive   = true
}

variable "security_analysts_group_object_id" {
  description = "Microsoft Entra object ID for the Security Analysts group. Supply securely at deployment time."
  type        = string
  sensitive   = true
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
