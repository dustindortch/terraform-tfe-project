# terraform-tfe-project

This module is used to create projects with their requisite workspaces in Terraform Enterprise or Terraform Cloud.  This can be used as part of a boostrapping effort to have TFE/TFC manage itself via Terraform.

TFE/TFC projects were added as a way to organization multiple workspaces and operate as a hierachical attachment point for permissions and the assignment of policies and variable sets.  This module is designed to create a project and its workspaces in a single module call.

The module follow a common pattern a object and children.  One project is created via the module and its workspaces are defined in a map of objects.  The workspaces are created as children of the project.

If multiple projects are required, for_each can be used when calling the module, which will create multiple projects and their workspaces.

Additional efforts can be aided by adding variables to the workspace for authentication to the provider endpoints.  This should be performed in parallel to this effort through dependency injection.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.50 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | ~> 0.50 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_project.project](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project) | resource |
| [tfe_workspace.workspaces](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | TFE/TFC project name | `string` | n/a | yes |
| <a name="input_oauth_token_id"></a> [oauth\_token\_id](#input\_oauth\_token\_id) | VCS OAuth token ID | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | TFE/TFC organization name | `string` | n/a | yes |
| <a name="input_workspaces"></a> [workspaces](#input\_workspaces) | TFE/TFC project workspaces | <pre>map(object({<br>    auto_apply = optional(bool, false)<br>    vcs_repo = object({<br>      identifier = string<br>    })<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project"></a> [project](#output\_project) | TFE/TFC project |
| <a name="output_workspace_ids"></a> [workspace\_ids](#output\_workspace\_ids) | TFE/TFC project workspaces |
<!-- END_TF_DOCS -->