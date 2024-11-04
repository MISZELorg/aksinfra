variable "resource_group_name" {
  description = "Name of the resource group for Monitoring"
  type        = string
}

variable "location" {
  description = "Location of the Monitoring resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "amw_name" {
  description = "Name of the Azure Monitor Workspace"
  type        = string
}

variable "grafana_name" {
  description = "Name of the Azure Monitor Workspace"
  type        = string
}

variable "dce_name" {
  description = "Name of the Data Collection Endpoint"
  type        = string
}

variable "prometheus_dcr_name" {
  description = "Name of the Prometheus Data Collection Rule"
  type        = string
}

variable "ci_dcr_name" {
  description = "Name of the Prometheus Data Collection Rule"
  type        = string
}

variable "workspace_id" {
  description = "Log Analytics Workspace ID"
  type        = string
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






