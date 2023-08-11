<div align="center">
<img src="coalfire_logo.png" width="200">

</div>

## ACE AWS Organizations Module

## Dependencies

List any dependencies here. E.g. security-core, region-setup

## Resource List

Insert a high-level list of resources created as a part of this module. E.g.

- Storage Account
- Containers
- Storage share
- Lifecycle policy
- CMK key and Iam Role Assignment
- Monitor diagnostic setting

## Code Updates

If applicable, add here. For example, updating variables, updating `tstate.tf`, or remote data sources.

`tstate.tf` Update to the appropriate version and storage accounts, see sample

``` hcl
terraform {
  required_version = "~>1.5.0"
  backend "s3" {
    profile        = "mgmt-prod"
    bucket         = "prod-us-gov-west-1-tf-state"
    region         = "us-gov-west-1"
    key            = "prod-us-gov-west-1-aws-org.tfstate"
    dynamodb_table = "prod-us-gov-west-1-state-lock"
    encrypt        = true
  }
}
```

Change directory to the `active-directory` folder

Run `terraform init` to download modules and create initial local state file.

Run `terraform plan` to ensure no errors and validate plan is deploying expected resources.

Run `terraform apply` to deploy infrastructure.

Update the `remote-data.tf` file to add the security state key

``` hcl
data "terraform_remote_state" "network-mgmt" {
  backend   = "s3"
  workspace = "default"

  config = {
    bucket  = "${var.resource_prefix}-${var.aws_region}-fr-tf-state"
    region  = var.aws_region
    key     = "prod-us-gov-west-1-aws-org.tfstate"
    profile = "mgmt-prod"
  }
}
```

## Deployment Steps

This module can be called as outlined below.

- Change directories to the `reponame` directory.
- From the `terraform/aws/reponame` directory run `terraform init`.
- Run `terraform plan` to review the resources being created.
- If everything looks correct in the plan output, run `terraform apply`.

## Usage

Include example for how to call the module below with generic variables

```hcl
provider "azurerm" {
  features {}
}

module "aws_org" {
  source                    = "github.com/Coalfire-CF/ACE-Azure-StorageAccount?ref=vX.X.X"
  service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]
  feature_set = "ALL"
  aws_new_member_account_email = "example@email.com"
  aws_new_member_account_name = "aws_account_12345"
  }
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_organizations_account.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_organizations_delegated_administrator.delegated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator) | resource |
| [aws_organizations_delegated_administrator.delegated_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator) | resource |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_new_member_account_email"></a> [aws\_new\_member\_account\_email](#input\_aws\_new\_member\_account\_email) | The Email address of the owner to assign to the new member account. This email address must not already be associated with another AWS account. | `any` | `null` | no |
| <a name="input_aws_new_member_account_name"></a> [aws\_new\_member\_account\_name](#input\_aws\_new\_member\_account\_name) | The Friendly name for the member account. | `any` | `null` | no |
| <a name="input_delegated_account_id"></a> [delegated\_account\_id](#input\_delegated\_account\_id) | The account ID number of the member account in the organization to register as a delegated administrator. | `list(string)` | `null` | no |
| <a name="input_delegated_service_principal"></a> [delegated\_service\_principal](#input\_delegated\_service\_principal) | The service principal of the AWS service for which you want to make the member account a delegated administrator. | `any` | `null` | no |
| <a name="input_feature_set"></a> [feature\_set](#input\_feature\_set) | Feature set to be used with Org and member accounts Specify ALL(default) or CONSOLIDATED\_BILLING. | `string` | `"ALL"` | no |
| <a name="input_service_access_principals"></a> [service\_access\_principals](#input\_service\_access\_principals) | List of AWS Service Access Prinicpals that you want to enable for organization integration | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accounts"></a> [accounts](#output\_accounts) | List of org accounts including master |
<!-- END_TF_DOCS -->

## Contributing

[Relative or absolute link to contributing.md](CONTRIBUTING.md)


## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)


## Coalfire Pages

[Absolute link to any relevant Coalfire Pages](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.
