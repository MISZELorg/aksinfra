variable "location" {
  description = "Azure region for the resources."
  type        = string
}

variable "subnets" {
  description = "Map of subnets with their names and address prefixes"
  type = map(object({
    address_prefix = string
  }))
}

variable "spoke_tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
}

variable "spoke_prefix" {
  description = "Prefix for the spoke resources."
  type        = string
}

variable "spoke_vnet_cidr" {
  description = "CIDR block for the spoke VNET."
  type        = list(string)
}

variable "hub_state_sub_id" {
  description = "Hub VNET subscription ID"
  type        = string
}

variable "hub_state_rg_name" {
  description = "Hub VNET resource group name."
  type        = string
}

variable "hub_state_sa_name" {
  description = "Hub VNET statefile storage account name."
  type        = string
}

variable "hub_state_container_name" {
  description = "Hub VNET statefile container name."
  type        = string
}

variable "hub_state_key" {
  description = "Hub VNET statefile name."
  type        = string
}

variable "hub_subscription_id" {
  description = "Hub VNET subscription ID."
  type        = string
}

variable "aks_appname" {
  description = "AKS workload name."
  type        = string
}

variable "maintenance_window" {
  description = "Map of maintenance window configuration"
  type        = map(string)
}

# The Public Domain for the public dns zone, that is used to register the hostnames assigned to the workloads hosted in AKS; if empty the dns zone not provisioned.
variable "public_domain" {
  description = "The Public Domain for the public dns zone, that is used to register the hostnames assigned to the workloads hosted in AKS; if empty the dns zone not provisioned."
  default     = ""
}

variable "aks_admins_group" {
  description = "AKS Admins EntraID group name."
  type        = string
}

variable "aks_users_group" {
  description = "AKS Users EntraID group name."
  type        = string
}

variable "network_plugin" {
  default = "azure"
}

variable "pod_cidr" {
  default = null
}


variable "streams" {
  description = "List of log streams"
  type        = list(string)
  default = ["Microsoft-ContainerLog", "Microsoft-ContainerLogV2", "Microsoft-KubeEvents",
    "Microsoft-KubePodInventory", "Microsoft-KubeNodeInventory",
    "Microsoft-KubePVInventory", "Microsoft-KubeServices",
    "Microsoft-KubeMonAgentEvents", "Microsoft-InsightsMetrics",
  "Microsoft-ContainerInventory", "Microsoft-ContainerNodeInventory", "Microsoft-Perf"]
}

variable "syslog_facilities" {
  description = "Syslog facilities"
  type        = list(string)
  default     = ["auth", "authpriv", "cron", "daemon", "mark", "kern", "local0", "local1", "local2", "local3", "local4", "local5", "local6", "local7", "lpr", "mail", "news", "syslog", "user", "uucp"]
}

variable "syslog_levels" {
  description = "Syslog levels"
  type        = list(string)
  default     = ["Debug", "Info", "Notice", "Warning", "Error", "Critical", "Alert", "Emergency"]
}

variable "data_collection_interval" {
  description = "Interval for data collection"
  type        = string
  default     = "1m"
}

variable "namespace_filtering_mode_for_data_collection" {
  description = "Namespace filtering mode for data collection"
  type        = string
  default     = "Off"
}

variable "namespaces_for_data_collection" {
  description = "Namespaces for data collection"
  type        = list(string)
  default     = ["kube-system", "gatekeeper-system", "azure-arc"]
}

variable "enableContainerLogV2" {
  description = "Enable Container Log V2"
  type        = bool
  default     = true
}