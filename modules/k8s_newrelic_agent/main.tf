resource "helm_release" "newrelic_agent" {
  name       = var.newrelic_agent_name
  repository = var.newrelic_agent_repository
  chart      = var.newrelic_agent_chart
  namespace  = var.newrelic_agent_namespace

  set {
    name  = "global.licenseKey"
    value = var.newrelic_agent_license_key
  }

  set {
    name  = "global.cluster"
    value = var.newrelic_agent_cluster
  }

  set {
    name  = "newrelic-infrastructure.privileged"
    value = "true"
  }

  set {
    name  = "global.lowDataMode"
    value = "true"
  }

  set {
    name  = "kube-state-metrics.image.tag"
    value = var.newrelic_agent_image_tag
  }

  set {
    name  = "kube-state-metrics.enabled"
    value = "true"
  }

  set {
    name  = "kubeEvents.enabled"
    value = "true"
  }

  set {
    name  = "newrelic-prometheus-agent.enabled"
    value = "true"
  }

  set {
    name  = "newrelic-prometheus-agent.lowDataMode"
    value = "true"
  }

  set {
    name  = "newrelic-prometheus-agent.config.kubernetes.integrations_filter.enabled"
    value = "false"
  }

  set {
    name  = "newrelic-pixie.enabled"
    value = "true"
  }

  set {
    name  = "newrelic-pixie.apiKey"
    value = var.newrelic_agent_pixie_api_key
  }

  set {
    name  = "pixie-chart.enabled"
    value = "true"
  }

  set {
    name  = "pixie-chart.deployKey"
    value = var.newrelic_agent_pixie_deploy_key
  }

  set {
    name  = "pixie-chart.clusterName"
    value = var.newrelic_agent_pixie_cluster_name
  }
}
