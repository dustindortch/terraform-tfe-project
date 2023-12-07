output "project" {
  description = "TFE/TFC project"
  value       = tfe_project.project
}

output "workspace_ids" {
  description = "TFE/TFC project workspaces"
  value       = tfe_workspace.workspaces.*.id
}
