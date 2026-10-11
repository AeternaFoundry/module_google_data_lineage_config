variable "data_lineage_configs" {
  description = <<EOT
Map of data_lineage_configs, attributes below
Required:
    - location
    - parent
    - ingestion (block):
        - rule (required, block):
            - integration_selector (required, block):
                - integration (required)
            - lineage_enablement (required, block):
                - enabled (required)
Optional:
    - deletion_policy
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    location        = string
    parent          = string
    deletion_policy = optional(string)
    ingestion = object({
      rule = list(object({
        integration_selector = object({
          integration = string
        })
        lineage_enablement = object({
          enabled = bool
        })
      }))
    })
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.data_lineage_configs : (
        length(v.ingestion.rule) >= 1
      )
    ])
    error_message = "Each rule list must contain at least 1 items"
  }
  # Note: 1 additional provider-side validator is enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

