resource "google_data_lineage_config" "data_lineage_configs" {
  for_each = var.data_lineage_configs

  location        = each.value.location
  parent          = each.value.parent
  deletion_policy = each.value.deletion_policy

  ingestion {
    dynamic "rule" {
      for_each = each.value.ingestion.rule
      content {
        integration_selector {
          integration = rule.value.integration_selector.integration
        }
        lineage_enablement {
          enabled = rule.value.lineage_enablement.enabled
        }
      }
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

