resource "azurerm_web_application_firewall_policy" "northstar" {
  name                = "northstar-lz-waf-policy"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  policy_settings {
    enabled = true
    mode    = "Detection"
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}
resource "azurerm_network_interface" "web" {
  name                = "northstar-lz-web-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.web_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "web" {
  name                            = "northstar-lz-web-01"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_D2as_v5"
  admin_username                  = "azureuser"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.web.id]
  tags                            = var.tags

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.admin_ssh_public_key
  }

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-CLOUD_INIT
#cloud-config
package_update: true
packages:
  - nginx
write_files:
  - path: /var/www/html/index.html
    permissions: "0644"
    content: |
      <!doctype html>
      <html>
      <head><title>NorthStar Secure Web Tier</title></head>
      <body>
        <h1>NorthStar Secure Web Tier</h1>
        <p>Private Nginx workload protected by Application Gateway WAF.</p>
      </body>
      </html>
runcmd:
  - systemctl enable nginx
  - systemctl restart nginx
CLOUD_INIT
  )
}
