terraform {
  required_version = "~> 1.9"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.58"
    }
  }
}

resource "tfe_project" "project" {
  organization = var.organization
  name         = var.name
}

resource "tfe_workspace" "workspaces" {
  for_each = var.workspaces

  name         = each.key
  organization = var.organization
  auto_apply   = false
  project_id   = tfe_project.project.id

  vcs_repo {
    branch         = each.value.vcs_repo.branch
    identifier     = each.value.vcs_repo.identifier
    oauth_token_id = var.oauth_token_id
  }

  lifecycle {
    ignore_changes = [
      vcs_repo[0].branch
    ]
    precondition {
      condition = anytrue([
        alltrue([
          length(var.workspaces) > 0,
          var.oauth_token_id != ""
        ]),
        alltrue([
          length(var.workspaces) == 0,
          anytrue([
            var.oauth_token_id == "",
            var.oauth_token_id != ""
          ])
        ])
      ])
      error_message = "oauth_token_id must also be defined if workspaces are declared."
    }
  }
}

locals {
  variables = merge(flatten([
    for k, v in var.workspaces : {
      for vk, vv in v.variables : "${k}_${vk}" => {
        workspace   = k
        key         = vk
        value       = vv.value
        category    = vv.category
        description = vv.description
        hcl         = vv.hcl
        sensitive   = vv.sensitive

      }
    }
  ])...)
}

resource "tfe_variable" "vars" {
  for_each = local.variables

  key          = each.value.key
  value        = each.value.value
  category     = each.value.category
  description  = each.value.description
  sensitive    = each.value.sensitive
  workspace_id = tfe_workspace.workspaces[each.value.workspace].id
}
