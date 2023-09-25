<div align="center">
<img src="coalfire_logo.png" width="200">

</div>

## ACE AWS Organizations Module

## Dependencies

- region-setup

## Resource List

A high-level list of resources created as a part of this module.

- AWS Organization with org level services
  - Guard Duty
  - Security Hub
  - AWS Config
  - Cloudtrail

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

Change directory to the `aws-org` folder

Run `terraform init` to download modules and create initial local state file.

Run `terraform plan` to ensure no errors and validate plan is deploying expected resources.

Run `terraform apply` to deploy infrastructure.

Update the `remote-data.tf` file to add the security state key

``` hcl
data "terraform_remote_state" "aws-org" {
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

- Change directories to the `aws-org` directory.
- From the `terraform/aws/aws-org` directory run `terraform init`.
- Run `terraform plan` to review the resources being created.
- If everything looks correct in the plan output, run `terraform apply`.

## Usage

Include example for how to call the module below with generic variables

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "=4.58"
    }
  }
}


module "aws_org" {
  source                    = "github.com/Coalfire-CF/ACE-AWS-Organiation?ref=vX.X.X"
  service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "securityhub.amazonaws.com",
    "guardduty.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com"
  ]
  feature_set = "ALL"
  aws_new_member_account_email = ["example@email.com"]
  aws_new_member_account_name = ["aws_account_12345"]
  delegated_admin_account_id = "12345678910"
  delegated_service_principal = "principal"
  aws_region = var.aws_region
  partition = var.partition
  resource_prefix = var.resource_prefix
  s3_kms_key_arn = data.terraform_remote_state.setup.outputs.s3_key_arn
  aws_sec_hub_standards_arn = ["arn:${var.partition}:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/1.4.0", "arn:${var.partition}:securityhub:${var.region}::standards/aws-foundational-security-best-practices/v/1.0.0"]
  }
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_aws.root"></a> [aws.root](#provider\_aws.root) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.org-trail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.guardduty](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_config_configuration_aggregator.organization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_aggregator) | resource |
| [aws_guardduty_detector.guardduty](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_guardduty_organization_admin_account.gh_admin_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_admin_account) | resource |
| [aws_guardduty_organization_configuration.guardduty](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration) | resource |
| [aws_guardduty_publishing_destination.gd_pub_dest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_publishing_destination) | resource |
| [aws_iam_role.aws_config_org_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.organization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.gd_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_organizations_account.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_organizations_delegated_administrator.delegated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator) | resource |
| [aws_organizations_delegated_administrator.delegated_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator) | resource |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |
| [aws_organizations_organizational_unit.ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_policy.scp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy_attachment.scp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_organizations_resource_policy.org_resource_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_resource_policy) | resource |
| [aws_s3_bucket.gd_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.gd_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.gd_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_securityhub_organization_admin_account.sechub_org_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_organization_admin_account) | resource |
| [aws_securityhub_organization_configuration.sechub_org_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_organization_configuration) | resource |
| [aws_securityhub_standards_subscription.cis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bucket_pol](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_pol](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.scp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_guardduty_datasources_enable_S3"></a> [aws\_guardduty\_datasources\_enable\_S3](#input\_aws\_guardduty\_datasources\_enable\_S3) | Configuration for the collected datasources. | `bool` | `true` | no |
| <a name="input_aws_guardduty_datasources_enable_k8_audit_logs"></a> [aws\_guardduty\_datasources\_enable\_k8\_audit\_logs](#input\_aws\_guardduty\_datasources\_enable\_k8\_audit\_logs) | Configuration for the collected datasources. | `bool` | `true` | no |
| <a name="input_aws_guardduty_datasources_enable_malware_protection_ebs"></a> [aws\_guardduty\_datasources\_enable\_malware\_protection\_ebs](#input\_aws\_guardduty\_datasources\_enable\_malware\_protection\_ebs) | Configuration for the collected datasources. | `bool` | `true` | no |
| <a name="input_aws_new_member_account_email"></a> [aws\_new\_member\_account\_email](#input\_aws\_new\_member\_account\_email) | The Email address of the owner to assign to the new member account. This email address must not already be associated with another AWS account. | `any` | `null` | no |
| <a name="input_aws_new_member_account_name"></a> [aws\_new\_member\_account\_name](#input\_aws\_new\_member\_account\_name) | The Friendly name for the member account. | `any` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | n/a | yes |
| <a name="input_aws_sec_hub_standards_arn"></a> [aws\_sec\_hub\_standards\_arn](#input\_aws\_sec\_hub\_standards\_arn) | n/a | `list[string]` | n/a | yes |
| <a name="input_create_org_cloudtrail"></a> [create\_org\_cloudtrail](#input\_create\_org\_cloudtrail) | True/False statement whether to enable AWS Cloudtrail in the Organization | `bool` | `true` | no |
| <a name="input_create_org_config"></a> [create\_org\_config](#input\_create\_org\_config) | True/False statement whether to enable AWS Config in the Organization | `bool` | `true` | no |
| <a name="input_create_org_guardduty"></a> [create\_org\_guardduty](#input\_create\_org\_guardduty) | True/False statement whether to enable AWS GuardDuty in the Organization | `bool` | `true` | no |
| <a name="input_create_org_securityhub"></a> [create\_org\_securityhub](#input\_create\_org\_securityhub) | True/False statement whether to enable AWS Security Hub in the Organization | `bool` | `true` | no |
| <a name="input_delegated_admin_account_id"></a> [delegated\_admin\_account\_id](#input\_delegated\_admin\_account\_id) | The account ID number of the member account in the organization to register as a delegated administrator. | `list(string)` | `null` | no |
| <a name="input_delegated_service_principal"></a> [delegated\_service\_principal](#input\_delegated\_service\_principal) | The service principal of the AWS service for which you want to make the member account a delegated administrator. | `any` | `null` | no |
| <a name="input_feature_set"></a> [feature\_set](#input\_feature\_set) | Feature set to be used with Org and member accounts Specify ALL(default) or CONSOLIDATED\_BILLING. | `string` | `"ALL"` | no |
| <a name="input_finding_publishing_frequency"></a> [finding\_publishing\_frequency](#input\_finding\_publishing\_frequency) | n/a | `string` | `"ONE_HOUR"` | no |
| <a name="input_ou_creation_info"></a> [ou\_creation\_info](#input\_ou\_creation\_info) | list of names of OU to create and their corresponding delegated admins | `any` | `null` | no |
| <a name="input_partition"></a> [partition](#input\_partition) | n/a | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_s3_kms_key_arn"></a> [s3\_kms\_key\_arn](#input\_s3\_kms\_key\_arn) | n/a | `string` | n/a | yes |
| <a name="input_service_access_principals"></a> [service\_access\_principals](#input\_service\_access\_principals) | List of AWS Service Access Principals that you want to enable for organization integration | `list(string)` | <pre>[<br>  "cloudtrail.amazonaws.com",<br>  "config.amazonaws.com",<br>  "securityhub.amazonaws.com",<br>  "guardduty.amazonaws.com",<br>  "config-multiaccountsetup.amazonaws.com"<br>]</pre> | no |

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
