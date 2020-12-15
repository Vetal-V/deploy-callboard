# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "callboard-kube-resource-group" {
    name     = "callboard-kube-resource-group"
    location = var.location

    tags = {
        environment = "Terraform"
    }
}