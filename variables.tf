variable "organization" {
  description = "TFC/TFE organization name"
  type        = string
}

variable "name" {
  description = "TFC/TFE project name"
  type        = string
}

locals {
  valid_execution_modes     = ["remote", "local", "agent"]
  valid_variable_categories = ["env", "terraform"]
}

variable "workspaces" {
  default     = {}
  description = "TFE/TFC project workspaces"
  type = map(object({
    agent_pool_id                  = optional(string, null)
    allow_destroy_plan             = optional(bool, false)
    auto_apply                     = optional(bool, false)
    auto_apply_run_trigger         = optional(bool, false)
    auto_destroy_activity_duration = optional(string, null)
    auto_destroy_at                = optional(string, null)
    description                    = optional(string, null)
    execution_mode                 = optional(string, null)
    file_triggers_enabled          = optional(bool, true)
    force_delete                   = optional(bool, false)
    global_remote_state            = optional(bool, false)
    queue_all_runs                 = optional(bool, true)
    remote_state_consumer_ids      = optional(list(string), [])
    speculative_enabled            = optional(bool, true)
    structured_run_output_enabled  = optional(bool, true)
    tag_names                      = optional(list(string), [])
    terraform_version              = optional(string, null)
    trigger_patterns               = optional(list(string), [])
    working_directory              = optional(string, null)

    vcs_repo = optional(object({
      branch             = optional(string, null)
      identifier         = string
      ingress_submodules = optional(bool, false)
      oauth_token_id     = optional(string, null)
      tags_regex         = optional(string, null)
    }), {})

    variables = optional(map(object({
      value       = string
      category    = optional(string, "terraform")
      description = optional(string, null)
      hcl         = optional(bool, false)
      sensitive   = optional(bool, false)
    })), {})
  }))

  validation {
    condition = alltrue([
      for k, v in values(var.workspaces) : contains(
        local.valid_variable_categories,
        v.category
      )
    ])
    error_message = "Variable category must be one of: ${join(", ", local.valid_variable_categories)}"
  }

  validation {
    condition = alltrue([
      for k, v in var.workspaces : !(
        v.auto_destroy_at != null && v.auto_destroy_activity_duration != null
      )
    ])
    error_message = "auto_destroy_at and auto_destroy_activity_duration are mutually exclusive."
  }

  validation {
    condition = alltrue([
      for k, v in var.workspaces : sum(
        length(v.triggers_patterns) > 0 ? 1 : 0,
        length(v.trigger_prefixes) > 0 ? 1 : 0,
        v.vcs_repo.tags_regex != null ? 1 : 0
      ) < 2
    ])
    error_message = "trigger_patterns, trigger_prefixes, and vcs_repo.tags_regex are mutually exclusive."
  }

  validation {
    condition = alltrue([
      for k, v in var.workspaces : anytrue([
        contains(local.valid_execution_modes, v.execution_mode),
        !(v.execution_mode != null)
      ])
    ])
    error_message = "execution_mode must be one of: ${join(", ", local.valid_execution_modes)}, or null"
  }

  validation {
    condition = alltrue([
      for k, v in var.workspaces : anytrue([
        !(v.agent_pool_id != null),
        v.execution_mode == "agent" && v.agent_pool_id != null
      ])
    ])
    error_message = "agent_pool_id required if execution_mode is agent"
  }
}

variable "oauth_token_id" {
  default     = null
  description = "VCS OAuth token ID"
  type        = string

  validation {
    condition = anytrue([
      length(var.workspaces) > 0 && var.oauth_token_id != null,
      length(var.workspaces) == 0
    ])
    error_message = "oauth_token_id must also be defined if workspaces are declared."
  }
}
