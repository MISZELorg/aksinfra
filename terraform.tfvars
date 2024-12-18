location         = "northeurope"
spoke_prefix     = "aztf-spoke"
spoke_vnet_cidr  = ["10.1.0.0/16"]
aks_appname      = "prvaks"
aks_admins_group = "AKS Admins Team"
aks_users_group  = "AKS Devs Team"

subnets = {
  "akssubnet"   = { address_prefix = "10.1.16.0/20" }
  "appgwsubnet" = { address_prefix = "10.1.1.0/24" }
}

spoke_tags = {
  Environment = "Dev"
  Owner       = "kmiszel"
  Source      = "Terraform"
  # Git         = "Github"
  # Purpose     = "spoke"
}

maintenance_window = {
  frequency   = "Weekly"
  duration    = "4"
  interval    = "1"
  day_of_week = "Sunday"
  start_time  = "00:00"
  start_date  = "2024-10-22T00:00:00Z"
  utc_offset  = "+00:00"
}

hub_state_sa_name        = "aztfconnectivity63"
hub_state_container_name = "terraform"
hub_state_sub_id         = "2745b794-365d-4993-9eec-fe3f9879434b"
hub_state_rg_name        = "aztf-backend-rg"
hub_state_key            = "tfstate"
hub_subscription_id      = "1c7e8402-ac8b-48d9-a8c8-f3de95064482"

github_repo = "git@github.com:MISZELorg/aksapps.git"