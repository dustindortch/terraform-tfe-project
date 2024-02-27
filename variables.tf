variable "organization" {
  description = "TFE/TFC organization name"
  type        = string
}

variable "name" {
  description = "TFE/TFC project name"
  type        = string
}

variable "workspaces" {
  default     = {}
  description = "TFE/TFC project workspaces"
  type = map(object({
    auto_apply = optional(bool, false)
    vcs_repo = object({
      identifier = string
      branch     = optional(string, "main")
    })
    variables = map(object({
      value       = string
      category    = optional(string, "terraform")
      description = optional(string, null)
      hcl         = optional(bool, false)
      sensitive   = optional(bool, false)
    }))
  }))

  validation {
    condition = alltrue(flatten([
      for k, v in var.workspaces : [
        for vk, vv in v.variables : can(contains(["env", "terraform"], vv.category))
      ]
    ]))
    error_message = "Variable category must be in env or terraform"
  }
}

variable "oauth_token_id" {
  default     = ""
  description = "VCS OAuth token ID"
  type        = string
}
