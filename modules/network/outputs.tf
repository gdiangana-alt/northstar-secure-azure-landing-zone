output "waf_subnet_id" {
  description = "Dedicated subnet ID for the Application Gateway WAF."
  value       = azurerm_subnet.waf.id
}
output "web_subnet_id" {
  description = "Private subnet ID for the web workload."
  value       = azurerm_subnet.web.id
}
