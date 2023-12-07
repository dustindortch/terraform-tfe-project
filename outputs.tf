output "project" {
  description = "TFE/TFC project"
  value       = tfe_project.project
}

output "workspace_ids" {
  description = "TFE/TFC project workspaces"
  value       = length(tfe_workspace.workspaces) > 0 ? tfe_workspace.workspaces.*.id : null
}
