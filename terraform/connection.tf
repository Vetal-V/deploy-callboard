#terrafor code to make Resorce group .. vm
# Configure the Microsoft Azure Provider
provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}

    subscription_id = var.subscription_id #find it there https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
}