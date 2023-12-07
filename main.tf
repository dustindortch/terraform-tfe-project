terraform {
  required_version = "~> 1.6"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.50"
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
    identifier     = each.value.vcs_repo.identifier
    oauth_token_id = var.oauth_token_id
  }

  lifecycle {
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
      error_message = "If workspaces are defined, then oauth_token_id must also be defined."
    }
  }
}
