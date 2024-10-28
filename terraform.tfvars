location        = "northeurope"
spoke_prefix    = "aztf-spoke"
spoke_vnet_cidr = ["10.1.0.0/16"]

subnets = {
  "akssubnet"   = { address_prefix = "10.1.16.0/20" }
  "appgwsubnet" = { address_prefix = "10.1.1.0/24" }
}

spoke_tags = {
  Environment = "Dev"
  Owner       = "kmiszel"
  Source      = "Terraform"
  Git         = "Github"
  Purpose     = "spoke"
}

state_sa_name  = "aztfconnectivity63"
container_name = "terraform"
hub_sub_id     = "1c7e8402-ac8b-48d9-a8c8-f3de95064482"
hub_rg_name    = "aztf-backend-rg"
key            = "tfstate"