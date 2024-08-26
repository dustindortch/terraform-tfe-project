# terraform-tfe-project

This module is used to create projects with their requisite workspaces in HCP Terraform or Terraform Enterprise.  This can be used as part of a boostrapping effort to have TFC/TFE manage itself via Terraform.

TFC/TFE projects were added as a way to organization multiple workspaces and operate as a hierachical attachment point for permissions and the assignment of policies and variable sets.  This module is designed to create a project and its workspaces in a single module call.

The module follow a common pattern an object and children.  One project is created via the module and its workspaces are defined in a map of objects.  The workspaces are created as children of the project.

If multiple projects are required, `for_each` can be used when calling the module, which will create multiple projects and their workspaces.

Additional efforts can be aided by adding variables to the workspace for authentication to the provider endpoints.  This should be performed in parallel to this effort through dependency injection.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.58 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | ~> 0.58 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_project.project](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project) | resource |
| [tfe_variable.vars](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_workspace.workspaces](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | TFE/TFC project name | `string` | n/a | yes |
| <a name="input_oauth_token_id"></a> [oauth\_token\_id](#input\_oauth\_token\_id) | VCS OAuth token ID | `string` | `""` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | TFE/TFC organization name | `string` | n/a | yes |
| <a name="input_workspaces"></a> [workspaces](#input\_workspaces) | TFE/TFC project workspaces | <pre>map(object({<br>    auto_apply = optional(bool, false)<br>    vcs_repo = object({<br>      identifier = string<br>      branch     = optional(string, "main")<br>    })<br>    variables = map(object({<br>      value       = string<br>      category    = optional(string, "terraform")<br>      description = optional(string, null)<br>      hcl         = optional(bool, false)<br>      sensitive   = optional(bool, false)<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project"></a> [project](#output\_project) | TFE/TFC project |
| <a name="output_workspaces"></a> [workspaces](#output\_workspaces) | TFE/TFC project workspaces |
<!-- END_TF_DOCS -->