terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "2.25"
    }
  }
}

provider "azurerm" {
    features {
    }
}

resource "azurerm_resource_group" "rg-aula-infra" {
    location = "westus"
    name = "rg-aula-infra"
}

resource "azurerm_kubernetes_cluster" "aks-aula-infra" {
  name                = "aks-aula-infra"
  location            = azurerm_resource_group.rg-aula-infra.location
  resource_group_name = azurerm_resource_group.rg-aula-infra.name
  dns_prefix          = "aks-aula-infra"

  default_node_pool {
    name       = "default"
    node_count = 1 
    vm_size    = "standard_d2_v5"
  }

  service_principal {
    client_id = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {
    http_application_routing {
      enabled = true
    }
  }

  tags = {
    Environment = "Production"
  }
}