# terraform-tfe-project

This module is used to create projects with their requisite workspaces in HCP Terraform or Terraform Enterprise.  This can be used as part of a boostrapping effort to have TFC/TFE manage itself via Terraform, as an "Account Factory", or as a self-service mechanism.

TFC/TFE projects were added as a way to organization multiple workspaces and operate as a hierachical attachment point for permissions and the assignment of policies and variable sets.  This module is designed to create a project and its workspaces in a single module call.

The module follow a common pattern an object and children.  One project is created via the module and its workspaces are defined in a map of objects.  The workspaces are created as children of the project.

If multiple projects are required, `for_each` can be used when calling the module, which will create multiple projects and their repspective workspaces.

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
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.58.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_project.project](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project) | resource |
| [tfe_variable.vars](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_workspace.workspaces](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |
| [tfe_workspace_settings.workspaces](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_settings) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | TFC/TFE project name | `string` | n/a | yes |
| <a name="input_oauth_token_id"></a> [oauth\_token\_id](#input\_oauth\_token\_id) | VCS OAuth token ID | `string` | `null` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | TFC/TFE organization name | `string` | n/a | yes |
| <a name="input_workspaces"></a> [workspaces](#input\_workspaces) | TFE/TFC project workspaces | <pre>map(object({<br>    agent_pool_id                  = optional(string, null)<br>    allow_destroy_plan             = optional(bool, false)<br>    auto_apply                     = optional(bool, false)<br>    auto_apply_run_trigger         = optional(bool, false)<br>    auto_destroy_activity_duration = optional(string, null)<br>    auto_destroy_at                = optional(string, null)<br>    description                    = optional(string, null)<br>    execution_mode                 = optional(string, null)<br>    file_triggers_enabled          = optional(bool, true)<br>    force_delete                   = optional(bool, false)<br>    global_remote_state            = optional(bool, false)<br>    queue_all_runs                 = optional(bool, true)<br>    remote_state_consumer_ids      = optional(list(string), [])<br>    speculative_enabled            = optional(bool, true)<br>    structured_run_output_enabled  = optional(bool, true)<br>    tag_names                      = optional(list(string), [])<br>    terraform_version              = optional(string, null)<br>    trigger_patterns               = optional(list(string), [])<br>    trigger_prefixes               = optional(list(string), [])<br>    working_directory              = optional(string, null)<br><br>    vcs_repo = object({<br>      branch             = optional(string, null)<br>      identifier         = string<br>      ingress_submodules = optional(bool, false)<br>      oauth_token_id     = optional(string, null)<br>      tags_regex         = optional(string, null)<br>    })<br><br>    variables = optional(map(object({<br>      value       = string<br>      category    = optional(string, "terraform")<br>      description = optional(string, null)<br>      hcl         = optional(bool, false)<br>      sensitive   = optional(bool, false)<br>    })), {})<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_description"></a> [description](#output\_description) | TFC/TFE project description |
| <a name="output_id"></a> [id](#output\_id) | TFC/TFE project ID |
| <a name="output_name"></a> [name](#output\_name) | TFC/TFE project name |
| <a name="output_workspaces"></a> [workspaces](#output\_workspaces) | TFE/TFC project workspaces |
<!-- END_TF_DOCS -->