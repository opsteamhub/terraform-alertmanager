## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.alertmanager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alertmanager"></a> [alertmanager](#input\_alertmanager) | n/a | <pre>map(object({<br>    alertmanager_enable = optional(bool, false)<br>    alertmanager_max_history = optional(number, 20)<br>    alertmanager_release_name = optional(string, "alertmanager")<br>    alertmanager_chart_name = optional(string, "alertmanager")<br>    alertmanager_chart_repository = optional(string, "https://prometheus-community.github.io/helm-charts")<br>    alertmanager_chart_version = optional(string, "")<br>    alertmanager_chart_namespace = optional(string, "default")<br>    alertmanager_repository = optional(string, "quay.io/prometheus/alertmanager")<br>    alertmanager_tag = optional(string, "v0.22.2")<br>    alertmanager_pull_policy = optional(string, "IfNotPresent")<br>    alertmanager_service_account = optional(string, "")<br>    alertmanager_service_account_annotations = optional(map(object({})))<br>    alertmanager_ingress_enabled = optional(bool, false)<br>    alertmanager_ingress_annotations = optional(map(object({})))<br>    alertmanager_ingress_hosts = optional(list(string))<br>    alertmanager_ingress_tls = optional(list(string))<br>    alertmanager_statefulset_annotations = optional(map(object({})))<br>    alertmanager_annotations = optional(map(object({})))<br>    alertmanager_tolerations = optional(list(string))<br>    alertmanager_node_selector = optional(map(object({})))<br>    alertmanager_affinity = optional(map(object({})))<br>    alertmanager_pv_enabled = optional(string, "true")<br>    alertmanager_pv_access_modes = optional(list(string), ["ReadWriteOnce"])<br>    alertmanager_pv_size = optional(string, "2Gi")<br>    alertmanager_storage_class = optional(string, "")<br>    alertmanager_replica = optional(number, 1)<br>    alertmanager_resources = optional(map(object({})))<br>    alertmanager_extra_args = optional(map(object({})))<br>    alertmanager_security_context = optional(object({<br>      fsGroup = optional(number, 65534)<br>      seccompProfile = optional(object({<br>        type = optional(string, "RuntimeDefault")<br>      }))<br>    }))<br>    alertmanager_container_security_context = optional(object({<br>      allowPrivilegeEscalation = optional(bool, false)<br>      runAsGroup               = optional(number, 65534)<br>      runAsNonRoot             = optional(bool, true)<br>      runAsUser                = optional(number, 65534)<br>    }))<br>    alertmanager_service_annotations = optional(object({}))<br>    alertmanager_service_port = optional(number, 9093)<br>    alertmanager_service_type = optional(string, "ClusterIP")<br>    alertmanager_pdb = optional(object({<br>      maxUnavailable = optional(number, 1)<br>    }))<br><br>    enable_slack_integration = optional(bool, false)<br>    slack_config = optional(map(object({<br>        slack_name = optional(string, "")<br>        slack_channel = optional(string, "")<br>        slack_api_url = optional(string)<br>        receiver_name = optional(string)<br>        severity = optional(string, "high")<br>        group_wait = optional(string, "10s")<br>        continue = optional(bool, true)<br>        repeat_interval = optional(string, "90m")<br>        group_interval = optional(string, "1h")<br>        <br>    })))<br>    enable_pagerduty_integration = optional(bool, false)<br>    pagerduty_config = optional(map(object({<br>        pagerduty_name = optional(string)<br>        pagerduty_key = optional(string)<br>        severity = optional(string, "high")<br>        group_by = optional(string, "alertname")<br>    })))<br><br>    configmap_name = optional(string, "alertmanager")<br>    configmap_image_repo = optional(string, "jimmidyson/configmap-reload")<br>    configmap_image_tag = optional(string, "v0.5.0")<br>    configmap_pull_policy = optional(string, "IfNotPresent")<br>    configmap_extra_args = optional(object({}))<br>    configmap_extra_volumes = optional(list(string), [])<br>    configmap_resources = optional(object({}))<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
