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
    })
  }))
}

variable "oauth_token_id" {
  default     = ""
  description = "VCS OAuth token ID"
  type        = string
}
