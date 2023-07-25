variable "alertmanager" {
  type = map(object({
    alertmanager_enable = optional(bool, false)
    alertmanager_max_history = optional(number, 20)
    alertmanager_release_name = optional(string, "alertmanager")
    alertmanager_chart_name = optional(string, "alertmanager")
    alertmanager_chart_repository = optional(string, "https://prometheus-community.github.io/helm-charts")
    alertmanager_chart_version = optional(string, "")
    alertmanager_chart_namespace = optional(string, "default")
    alertmanager_repository = optional(string, "quay.io/prometheus/alertmanager")
    alertmanager_tag = optional(string, "v0.22.2")
    alertmanager_pull_policy = optional(string, "IfNotPresent")
    alertmanager_service_account = optional(string, "")
    alertmanager_service_account_annotations = optional(map(object({})))
    alertmanager_ingress_enabled = optional(bool, false)
    alertmanager_ingress_annotations = optional(map(object({})))
    alertmanager_ingress_hosts = optional(list(string))
    alertmanager_ingress_tls = optional(list(string))
    alertmanager_statefulset_annotations = optional(map(object({})))
    alertmanager_annotations = optional(map(object({})))
    alertmanager_tolerations = optional(list(string))
    alertmanager_node_selector = optional(map(object({})))
    alertmanager_affinity = optional(map(object({})))
    alertmanager_pv_enabled = optional(string, "true")
    alertmanager_pv_access_modes = optional(list(string), ["ReadWriteOnce"])
    alertmanager_pv_size = optional(string, "2Gi")
    alertmanager_storage_class = optional(string, "gp2")
    alertmanager_replica = optional(number, 1)
    alertmanager_resources = optional(map(object({})))
    alertmanager_extra_args = optional(map(object({})))
    alertmanager_security_context = optional(object({
      fsGroup = optional(number, 65534)
      seccompProfile = optional(object({
        type = optional(string, "RuntimeDefault")
      }))
    }))
    alertmanager_container_security_context = optional(object({
      allowPrivilegeEscalation = optional(bool, false)
      runAsGroup               = optional(number, 65534)
      runAsNonRoot             = optional(bool, true)
      runAsUser                = optional(number, 65534)
    }))
    alertmanager_service_annotations = optional(object({}))
    alertmanager_service_port = optional(number, 9093)
    alertmanager_service_type = optional(string, "ClusterIP")
    alertmanager_pdb = optional(object({
      maxUnavailable = optional(number, 1)
    }))

    enable_slack_integration = optional(bool, false)
    slack_config = optional(map(object({
        slack_name = optional(string, "")
        slack_channel = optional(string, "")
        slack_api_url = optional(string)
        receiver_name = optional(string)
        severity = optional(string, "high")
        group_wait = optional(string, "10s")
        continue = optional(bool, true)
        repeat_interval = optional(string, "90m")
        group_interval = optional(string, "1h")
        
    })))
    enable_pagerduty_integration = optional(bool, false)
    pagerduty_config = optional(map(object({
        pagerduty_name = optional(string)
        pagerduty_key = optional(string)
        severity = optional(string, "high")
        group_by = optional(string, "alertname")
    })))

    configmap_name = optional(string, "alertmanager")
    configmap_image_repo = optional(string, "jimmidyson/configmap-reload")
    configmap_image_tag = optional(string, "v0.5.0")
    configmap_pull_policy = optional(string, "IfNotPresent")
    configmap_extra_args = optional(object({}))
    configmap_extra_volumes = optional(list(string), [])
    configmap_resources = optional(object({}))
  }))
  default = {}
}