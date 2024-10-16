![Coalfire](coalfire_logo.png)

## ACE AWS Organizations Terraform Module

## Description
This module sets up an AWS Organization with org-level services, including Guard Duty, Security Hub, AWS Config, and Cloudtrail.

FedRAMP Compliance: Moderate, High

## Dependencies

- Region Setup

## Resource List

A high-level list of resources created as a part of this module.

- AWS Organization with org level services
  - Cloudtrail
- AWS Organization policy
- IAM role and policy

## Related Repos 

AWS resources that can be used with Organizations
- [AWS Config](https://github.com/Coalfire-CF/terraform-aws-config)
- [AWS Guardduty](https://github.com/Coalfire-CF/terraform-aws-guardduty)
- [AWS SecurityHub](https://github.com/Coalfire-CF/terraform-aws-security-hub)
- [AWS Control Tower](https://github.com/Coalfire-CF/terraform-aws-control-tower)

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
      source  = "hashicorp/aws"
      version = "=4.58"
    }
  }
}


module "aws_org" {
  source = "github.com/Coalfire-CF/terraform-aws-organization"
  service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "sso.amazonaws.com",
    "ssm.amazonaws.com",
    "servicecatalog.amazonaws.com",
    "guardduty.amazonaws.com",
    "controltower.amazonaws.com",
    "securityhub.amazonaws.com",
    "ram.amazonaws.com",
    "tagpolicies.tag.amazonaws.com"
  ]
  feature_set                  = "ALL"
  aws_new_member_account_email = ["example@email.com"]
  aws_new_member_account_name  = ["aws_account_12345"]
  delegated_admin_account_id   = "12345678910"
  delegated_service_principal  = "principal"
  aws_region                   = var.aws_region
  partition                    = var.partition
  resource_prefix              = var.resource_prefix
  s3_kms_key_arn               = data.terraform_remote_state.setup.outputs.s3_key_arn
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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_guardduty_kms_key"></a> [guardduty\_kms\_key](#module\_guardduty\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | n/a |

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
| [aws_organizations_account.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_organizations_delegated_administrator.delegated_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator) | resource |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |
| [aws_organizations_organizational_unit.ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_policy.scp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy_attachment.scp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_organizations_resource_policy.org_resource_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_resource_policy) | resource |
| [aws_s3_bucket.gd_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.gd_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_securityhub_organization_admin_account.sechub_org_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_organization_admin_account) | resource |
| [aws_securityhub_organization_configuration.sechub_org_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_organization_configuration) | resource |
| [aws_securityhub_standards_subscription.cis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bucket_pol](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_pol](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.scp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_guardduty_datasources_enable_S3"></a> [aws\_guardduty\_datasources\_enable\_S3](#input\_aws\_guardduty\_datasources\_enable\_S3) | Configuration for the collected datasources. | `bool` | `true` | no |
| <a name="input_aws_guardduty_datasources_enable_k8_audit_logs"></a> [aws\_guardduty\_datasources\_enable\_k8\_audit\_logs](#input\_aws\_guardduty\_datasources\_enable\_k8\_audit\_logs) | Configuration for the collected datasources. | `bool` | `true` | no |
| <a name="input_aws_guardduty_datasources_enable_malware_protection_ebs"></a> [aws\_guardduty\_datasources\_enable\_malware\_protection\_ebs](#input\_aws\_guardduty\_datasources\_enable\_malware\_protection\_ebs) | Configuration for the collected datasources. | `bool` | `true` | no |
| <a name="input_aws_new_member_account_email"></a> [aws\_new\_member\_account\_email](#input\_aws\_new\_member\_account\_email) | The Email address of the owner to assign to the new member account. This email address must not already be associated with another AWS account. | `any` | `null` | no |
| <a name="input_aws_new_member_account_name"></a> [aws\_new\_member\_account\_name](#input\_aws\_new\_member\_account\_name) | The Friendly name for the member account. | `any` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | n/a | yes |
| <a name="input_aws_sec_hub_standards_arn"></a> [aws\_sec\_hub\_standards\_arn](#input\_aws\_sec\_hub\_standards\_arn) | n/a | `list(string)` | n/a | yes |
| <a name="input_create_org_cloudtrail"></a> [create\_org\_cloudtrail](#input\_create\_org\_cloudtrail) | True/False statement whether to enable AWS Cloudtrail in the Organization | `bool` | `true` | no |
| <a name="input_create_org_config"></a> [create\_org\_config](#input\_create\_org\_config) | True/False statement whether to enable AWS Config in the Organization | `bool` | `true` | no |
| <a name="input_create_org_guardduty"></a> [create\_org\_guardduty](#input\_create\_org\_guardduty) | True/False statement whether to enable AWS GuardDuty in the Organization | `bool` | `true` | no |
| <a name="input_create_org_securityhub"></a> [create\_org\_securityhub](#input\_create\_org\_securityhub) | True/False statement whether to enable AWS Security Hub in the Organization | `bool` | `true` | no |
| <a name="input_delegated_admin_account_id"></a> [delegated\_admin\_account\_id](#input\_delegated\_admin\_account\_id) | The account ID number of the member account in the organization to register as a delegated administrator. | `list(string)` | `null` | no |
| <a name="input_delegated_service_principal"></a> [delegated\_service\_principal](#input\_delegated\_service\_principal) | The service principal of the AWS service for which you want to make the member account a delegated administrator. | `string` | `"principal"` | no |
| <a name="input_feature_set"></a> [feature\_set](#input\_feature\_set) | Feature set to be used with Org and member accounts Specify ALL(default) or CONSOLIDATED\_BILLING. | `string` | `"ALL"` | no |
| <a name="input_finding_publishing_frequency"></a> [finding\_publishing\_frequency](#input\_finding\_publishing\_frequency) | n/a | `string` | `"ONE_HOUR"` | no |
| <a name="input_org_account_name"></a> [org\_account\_name](#input\_org\_account\_name) | value to be used for the org account name | `string` | n/a | yes |
| <a name="input_ou_creation_info"></a> [ou\_creation\_info](#input\_ou\_creation\_info) | list of names of OU to create and their corresponding delegated admins | `map(map(string))` | <pre>{<br>  "ou1": {<br>    "ou_name": "app_ou1",<br>    "ou_parent_id": "parent_id1"<br>  },<br>  "ou2": {<br>    "ou_name": "app_ou2",<br>    "ou_parent_id": "parent_id2"<br>  }<br>}</pre> | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_s3_kms_key_arn"></a> [s3\_kms\_key\_arn](#input\_s3\_kms\_key\_arn) | n/a | `string` | n/a | yes |
| <a name="input_service_access_principals"></a> [service\_access\_principals](#input\_service\_access\_principals) | List of AWS Service Access Principals that you want to enable for organization integration | `list(string)` | <pre>[<br>  "cloudtrail.amazonaws.com",<br>  "config.amazonaws.com",<br>  "securityhub.amazonaws.com",<br>  "guardduty.amazonaws.com",<br>  "config-multiaccountsetup.amazonaws.com"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accounts"></a> [accounts](#output\_accounts) | List of org accounts including master |
| <a name="output_master_account_id"></a> [master\_account\_id](#output\_master\_account\_id) | Master account ID |
<!-- END_TF_DOCS -->

## Contributing

[Relative or absolute link to contributing.md](CONTRIBUTING.md)


## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)


## Coalfire Pages

[Absolute link to any relevant Coalfire Pages](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.
