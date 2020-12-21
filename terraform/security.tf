# Create Network Security Group and rule
resource "azurerm_network_security_group" "callboard-kube-network-sg" {
    name                = "callboard-kube-network-sg"
    location            = var.location
    resource_group_name = azurerm_resource_group.callboard-kube-resource-group.name 

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "Django"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "30000"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "Frontend"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "30100"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    count                     = var.instance_count
    network_interface_id      = azurerm_network_interface.callboard-kube-nic[count.index].id
    network_security_group_id = azurerm_network_security_group.callboard-kube-network-sg.id
}