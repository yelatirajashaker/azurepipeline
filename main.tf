provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "raj_rg" {
  name     = "raj_rg"
  location = "East US"  # Replace with your desired region
}

resource "azurerm_storage_account" "tf_state_storage" {
  name                     = "yelati23"
  resource_group_name      = azurerm_resource_group.raj_rg.name
  location                 = azurerm_resource_group.raj_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "reddy"
  }
}

resource "azurerm_storage_container" "tf_state_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tf_state_storage.name
  container_access_type = "private"
}

resource "random_string" "random_name" {
  length  = 6
  special = false
}

resource "azurerm_kubernetes_cluster" "aks_sp" {
  name                = "aks-sp"
  location            = azurerm_resource_group.raj_rg.location
  resource_group_name = azurerm_resource_group.raj_rg.name
  dns_prefix          = "aks-sp-${random_string.random_name.result}"
  kubernetes_version = "1.25.11"  # Replace with your desired Kubernetes version

  default_node_pool {
    name       = "default"
    node_count = 1  # We don't need any nodes for the SP cluster
    vm_size = "Standard_B2ms"
  }

  service_principal {
    client_id     = "3d452dbd-a91f-4913-95a5-22a578358201"
    client_secret = "IyQ8Q~FtoMem.pgbOam4KJ8v6LdLsvubxy.WBb~M"
  }

  tags = {
    environment = "reddy"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks_sp.kube_config_raw
  sensitive = true
}