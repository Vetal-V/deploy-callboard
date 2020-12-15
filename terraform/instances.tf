# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "storageaccount1cc"
    resource_group_name         = azurerm_resource_group.callboard-kube-resource-group.name 
    location                    = var.location
    account_tier                = "Standard" 
    account_replication_type    = "LRS"

    tags = {
        environment = "Terraform"
    }
}

# Create virtual machines
resource "azurerm_linux_virtual_machine" "callboard-kube-vm" {
    count                 = var.instance_count
    name                  = "callboard-kube-vm${count.index}"
    location              = var.location
    resource_group_name   = azurerm_resource_group.callboard-kube-resource-group.name 
    network_interface_ids = [element(azurerm_network_interface.callboard-kube-nic.*.id, count.index)]
    size                  = "Standard_B2s"
    # size                  = "Standard_B1ms"

    os_disk {
        name              = "callboard-kube-osdisk${count.index}"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS" 
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "myvm${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
    disable_password_authentication = false

    #no ssh
    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform"
    }
}

output "username" {
    value = var.admin_username
}

output "password" {
    value = var.admin_password
}