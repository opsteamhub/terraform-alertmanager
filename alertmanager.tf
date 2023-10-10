resource "helm_release" "alertmanager" {
  for_each = { for k, v in var.alertmanager :
    k => v if try(v["alertmanager_enable"], false) == true
  }

  name       = each.value["alertmanager_release_name"]
  chart      = each.value["alertmanager_chart_name"]
  repository = each.value["alertmanager_chart_repository"]
  version    = each.value["alertmanager_chart_version"]
  namespace  = each.value["alertmanager_chart_namespace"]

  max_history = each.value["alertmanager_max_history"]


  values = [templatefile(
    "${path.module}/templates/alertmanager.yaml", {
      repository                  = each.value["alertmanager_repository"],
      tag                         = each.value["alertmanager_tag"],
      pull_policy                 = each.value["alertmanager_pull_policy"],
      replica                     = each.value["alertmanager_replica"],
      resources                   = jsonencode(each.value["alertmanager_resources"]),
      service_account             = each.value["alertmanager_service_account"],
      service_account_annotations = jsonencode(each.value["alertmanager_service_account_annotations"]),
      statefulset_annotations     = jsonencode(each.value["alertmanager_statefulset_annotations"]),
      annotations                 = jsonencode(each.value["alertmanager_annotations"]),
      tolerations                 = jsonencode(each.value["alertmanager_tolerations"]),
      node_selector               = jsonencode(each.value["alertmanager_node_selector"]),
      affinity                    = jsonencode(each.value["alertmanager_affinity"]),
      security_context            = jsonencode(each.value["alertmanager_security_context"]),
      container_security_context  = jsonencode(each.value["alertmanager_container_security_context"]),
      #extra_args                  = jsonencode(each.value["alertmanager_extra_args"]),
      service_annotations         = jsonencode(each.value["alertmanager_service_annotations"]),
      service_port                = each.value["alertmanager_service_port"],
      service_type                = each.value["alertmanager_service_type"],
      ingress_enabled             = each.value["alertmanager_ingress_enabled"],
      ingress_annotations         = jsonencode(each.value["alertmanager_ingress_annotations"]),
      ingress_hosts               = jsonencode(each.value["alertmanager_ingress_hosts"]),
      ingress_tls                 = jsonencode(each.value["alertmanager_ingress_tls"]),
      pv_enabled                  = each.value["alertmanager_pv_enabled"],
      pv_access_modes             = jsonencode(each.value["alertmanager_pv_access_modes"]),
      pv_size                     = each.value["alertmanager_pv_size"],
      storage_class               = each.value["alertmanager_storage_class"],
      pdb                         = jsonencode(each.value["alertmanager_pdb"]),
      config = indent(2, templatefile(
        "${path.module}/templates/config.tpl", {

          slack_config                 = each.value["slack_config"]
          pagerduty_config             = each.value["pagerduty_config"]
          enable_slack_integration     = each.value["enable_slack_integration"]
          enable_pagerduty_integration = each.value["enable_pagerduty_integration"]
        }
      ))
      configmap_name              = each.value["configmap_name"],
      configmap_image_repo        = each.value["configmap_image_repo"],
      configmap_image_tag         = each.value["configmap_image_tag"],
      configmap_image_pull_policy = each.value["configmap_pull_policy"],
      configmap_resources         = jsonencode(each.value["configmap_resources"]),
    }
    )
  ]
}

