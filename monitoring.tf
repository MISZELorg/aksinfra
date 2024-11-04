module "aks-monitoring" {
  source = "./modules/aks-monitoring"

  resource_group_name = "${var.aks_appname}-monitoring-rg"
  location            = module.spoke_networking.spoke_rg_location
  tags                = var.spoke_tags
  amw_name            = "${var.aks_appname}-amw"
  grafana_name        = "${var.aks_appname}-grafana"
  dce_name            = "${var.aks_appname}-dce"
  prometheus_dcr_name = "MSProm-${module.aks-monitoring.location}-${var.aks_appname}"
  ci_dcr_name         = "MSCI-${module.aks-monitoring.location}-${var.aks_appname}"
  workspace_id        = module.laws.log_analytics_workspace_id

  depends_on = [
    module.aks
  ]
}

module "eid_role_assignment-grafana_admin" {
  source = "./modules/EID_role_assignment"

  role_definition_name = "Grafana Admin"
  scope                = module.aks-monitoring.grafana_id
  eid_group_ids = [
    module.aks_eid_groups.aksadmins_object_id
  ]
  depends_on = [
    module.aks-monitoring
  ]
}

module "eid_role_assignment-grafana_viewer" {
  source = "./modules/EID_role_assignment"

  role_definition_name = "Grafana Viewer"
  scope                = module.aks-monitoring.grafana_id
  eid_group_ids = [
    module.aks_eid_groups.aksusers_object_id
  ]
  depends_on = [
    module.aks-monitoring
  ]
}

resource "azurerm_monitor_data_collection_rule_association" "aks_amwdcra" {
  for_each                = { for k, v in module.aks : k => v }
  name                    = "MSProm-${module.aks-monitoring.location}-${var.aks_appname}"
  target_resource_id      = each.value.aks_id
  data_collection_rule_id = module.aks-monitoring.promdcr_id
  depends_on = [
    module.aks-monitoring,
    module.aks
  ]
}

resource "azurerm_monitor_data_collection_rule_association" "aks_cidcra" {
  for_each                = { for k, v in module.aks : k => v }
  name                    = "MSCi-${module.aks-monitoring.location}-${var.aks_appname}"
  target_resource_id      = each.value.aks_id
  data_collection_rule_id = module.aks-monitoring.cidcr_id
  depends_on = [
    module.aks-monitoring,
    module.aks
  ]
}

resource "kubernetes_config_map" "prometheus_recording_rules" {
  metadata {
    name      = "prometheus-recording-rules"
    namespace = "monitoring"
  }

  data = {
    "recording_rules.yml" = file("${path.module}/recording_rules.yml")
  }
}