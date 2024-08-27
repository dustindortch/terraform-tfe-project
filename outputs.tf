output "description" {
  description = "TFC/TFE project description"
  value       = tfe_project.project.description
}

output "id" {
  description = "TFC/TFE project ID"
  value       = tfe_project.project.id
}

output "name" {
  description = "TFC/TFE project name"
  value       = tfe_project.project.name
}

output "workspaces" {
  description = "TFE/TFC project workspaces"
  value = {
    for k, v in tfe_workspace.workspaces : k => merge(
      v,
      tfe_workspace_settings.workspaces[k]
    )
  }
}
