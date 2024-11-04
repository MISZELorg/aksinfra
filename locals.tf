locals {
  appgws = {
    "appgw_blue" = {
      name_prefix   = "blue"
      appgw_turn_on = true
    },
    "appgw_green" = {
      name_prefix   = "green"
      appgw_turn_on = false
    }
  }
}

locals {
  aks_clusters = {
    "aks_blue" = {
      name_prefix = "blue"
      aks_turn_on = true
      k8s_version = "1.29"
      appgw_name  = "blue-appgw"
    },
    "aks_green" = {
      name_prefix = "green"
      aks_turn_on = false
      k8s_version = "1.29"
      appgw_name  = "green-appgw"
    }
  }
}