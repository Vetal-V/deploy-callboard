# Create virtual network
resource "azurerm_virtual_network" "callboard-kube-virtualnetwork" {
    name                = "callboard-kube-virtualnetwork"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.callboard-kube-resource-group.name 

    tags = {
        environment = "Terraform"
    }
}

# Create subnet
resource "azurerm_subnet" "callboard-kube-subnet" {
    name                 = "callboard-kube-subnet"
    resource_group_name  = azurerm_resource_group.callboard-kube-resource-group.name 
    virtual_network_name = azurerm_virtual_network.callboard-kube-virtualnetwork.name 
    address_prefix       = "10.0.1.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "callboard-kube-publicip" {
    count                        = var.instance_count
    name                         = "callboard-kube-publicip${count.index}"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.callboard-kube-resource-group.name 
    allocation_method            = "Static"

    tags = {
        environment = "Terraform"
    }
}

# Create network interface
resource "azurerm_network_interface" "callboard-kube-nic" {
    count               = var.instance_count
    name                = "callboard-kube-nic${count.index}"
    location            = var.location
    resource_group_name = azurerm_resource_group.callboard-kube-resource-group.name 

    ip_configuration {
        name                          = "callboard-kube-nic-config"
        subnet_id                     = azurerm_subnet.callboard-kube-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.callboard-kube-publicip[count.index].id
    }

    tags = {
        environment = "Terraform"
    }
}

output "public_ip" {
    value = azurerm_public_ip.callboard-kube-publicip.*.ip_address
}