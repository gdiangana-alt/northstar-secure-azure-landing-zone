output "waf_subnet_id" {
  description = "Dedicated subnet ID for the Application Gateway WAF."
  value       = azurerm_subnet.waf.id
}
