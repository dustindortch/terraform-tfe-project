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
  project_id   = tfe_project.project.id

  allow_destroy_plan             = each.value.allow_destroy_plan
  auto_apply                     = each.value.auto_apply
  auto_apply_run_trigger         = each.value.auto_apply_run_trigger
  auto_destroy_activity_duration = each.value.auto_destroy_activity_duration
  auto_destroy_at                = each.value.auto_destroy_at
  description                    = each.value.description
  file_triggers_enabled          = each.value.file_triggers_enabled
  force_delete                   = each.value.force_delete
  global_remote_state            = each.value.global_remote_state
  queue_all_runs                 = each.value.queue_all_runs
  remote_state_consumer_ids      = each.value.remote_state_consumer_ids
  speculative_enabled            = each.value.speculative_enabled
  structured_run_output_enabled  = each.value.structured_run_output_enabled
  tag_names                      = each.value.tag_names
  terraform_version              = each.value.terraform_version
  trigger_patterns               = each.value.trigger_patterns
  working_directory              = each.value.working_directory

  vcs_repo {
    branch             = each.value.vcs_repo.branch
    identifier         = each.value.vcs_repo.identifier
    ingress_submodules = each.value.vcs_repo.ingress_submodules
    oauth_token_id = coalesce(
      each.value.vcs_repo.oauth_token_id,
      var.oauth_token_id
    )
  }

  lifecycle {
    ignore_changes = [
      vcs_repo[0].branch
    ]
  }
}

resource "tfe_workspace_settings" "workspaces" {
  for_each = var.workspaces

  workspace_id   = tfe_workspace.workspaces[each.key].id
  agent_pool_id  = each.value.agent_pool_id
  execution_mode = each.value.execution_mode
}

locals {
  variables = merge(flatten([
    for ki, vi in var.workspaces : {
      for kj, vj in vi.variables : "${ki}_${kj}" => {
        workspace   = ki
        key         = kj
        value       = vj.value
        category    = vj.category
        description = vj.description
        hcl         = vj.hcl
        sensitive   = vj.sensitive
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
