variable "resource_group_name" {
  type = string
}

variable "resource_group_id" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}
variable "cloud_admins_group_object_id" {
  description = "Object ID of the NorthStar Cloud Admins Entra group."
  type        = string
}

variable "security_analysts_group_object_id" {
  description = "Object ID of the NorthStar Security Analysts Entra group."
  type        = string
}
