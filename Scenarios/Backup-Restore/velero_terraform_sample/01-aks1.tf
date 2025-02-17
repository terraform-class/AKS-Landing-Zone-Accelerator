
resource "azurerm_resource_group" "aks_testvelero" {
  name     = "primary-aks1"
  location = var.region
  tags     = var.tags
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = "primary-aks1"
  location = var.region
  resource_group_name = azurerm_resource_group.aks_testvelero.name
  dns_prefix          = "primaryaks1"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS3_v2"
    availability_zones = ["1", "2", "3"]
  }


 role_based_access_control {
    enabled = true

  }

  identity {
    type                      = "SystemAssigned"
  }

  network_profile {
    network_plugin     = var.network_profile.network_plugin
    network_policy     = var.network_profile.network_policy
    dns_service_ip     = var.network_profile.dns_service_ip
    docker_bridge_cidr = var.network_profile.docker_bridge_cidr
    service_cidr       = var.network_profile.service_cidr
    load_balancer_sku  = var.network_profile.load_balancer_sku
  }



  tags = {
    Environment = "DEV"
  }
}


# Allow AKS identity to manage AKS items in MC_xxx RG
resource "azurerm_role_assignment" "aks_mc_rg" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  scope                = format("/subscriptions/%s/resourceGroups/%s", data.azurerm_subscription.current.subscription_id, azurerm_kubernetes_cluster.aks.node_resource_group)
  role_definition_name = "Contributor"
}


