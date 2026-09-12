data "azuread_group" "employees" {
  display_name = "NorthStar-Employees"
}

data "azuread_group" "app_developers" {
  display_name = "NorthStar-App-Developers"
}

data "azuread_group" "security_analysts" {
  display_name = "NorthStar-Security-Analysts"
}

data "azuread_group" "cloud_admins" {
  display_name = "NorthStar-Cloud-Admins"
}
