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

AWS resources that can be used with Organizations:
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

## Service Control Policy Usage

Included in the [available-SCPs](file://available-SCPs) directory are a set of commonly used Service Control Policies, 
otherwise known as SCPs. These SCPs can be used to strengthen your AWS Organization's security posture 

Each of them can be modified to meet your needs, such as partition changes, additional tags, or any additional roles to be 
permitted to perform certain actions.

This [link](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_evaluation.html) can help visualize how to assign your SCPs, whether root, OU or account based.

Copy and save any applicable SCP terraform files in the same directory as where you called the terraform-aws-organization module

Below is some examples of how you can use and apply SCPs to your organization.

Creating a policy:
```terraform
resource "aws_organizations_policy" "DenyLeavingOrg" {
  name    = "Prevent member accounts from leaving the organization"
  content = data.aws_iam_policy_document.example.json
}
```

Account targeted SCP
```hcl
resource "aws_organizations_policy_attachment" "ProdDenyOrgLeavy" {
  policy_id = aws_organizations_policy.DenyLeavingOrg.id
  target_id = "123456789012"
}
```

Org Root targeted SCP
```hcl
resource "aws_organizations_policy_attachment" "RootDenyOrgLeavy" {
  policy_id = aws_organizations_policy.DenyLeavingOrg.id
  target_id = aws_organizations_organization.gov-org.roots[0].id
}
```

Org Unit targeted SCP
```hcl
resource "aws_organizations_policy_attachment" "ProdOUDenyOrgLeavy" {
  policy_id = aws_organizations_policy.DenyLeavingOrg.id
  target_id = aws_organizations_organizational_unit.prod.id
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
| [aws_cloudtrail.org-trail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_iam_role.aws_config_org_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.organization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | n/a | yes |
| <a name="input_create_org_cloudtrail"></a> [create\_org\_cloudtrail](#input\_create\_org\_cloudtrail) | True/False statement whether to enable AWS Cloudtrail in the Organization | `bool` | `false` | no |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | List of Organizations policy types to enable in the Organization Root. Organization must have feature\_set set to ALL. For additional information about valid policy types (e.g., AISERVICES\_OPT\_OUT\_POLICY, BACKUP\_POLICY, SERVICE\_CONTROL\_POLICY, and TAG\_POLICY) | `list(string)` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_feature_set"></a> [feature\_set](#input\_feature\_set) | Feature set to be used with Org and member accounts Specify ALL(default) or CONSOLIDATED\_BILLING. | `string` | `"ALL"` | no |
| <a name="input_org_account_name"></a> [org\_account\_name](#input\_org\_account\_name) | value to be used for the org account name | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_s3_kms_key_arn"></a> [s3\_kms\_key\_arn](#input\_s3\_kms\_key\_arn) | n/a | `string` | `null` | no |
| <a name="input_service_access_principals"></a> [service\_access\_principals](#input\_service\_access\_principals) | List of AWS Service Access Principals that you want to enable for organization integration | `list(string)` | <pre>[<br/>  "cloudtrail.amazonaws.com",<br/>  "config.amazonaws.com",<br/>  "config-multiaccountsetup.amazonaws.com",<br/>  "member.org.stacksets.cloudformation.amazonaws.com",<br/>  "sso.amazonaws.com",<br/>  "ssm.amazonaws.com",<br/>  "servicecatalog.amazonaws.com",<br/>  "guardduty.amazonaws.com",<br/>  "controltower.amazonaws.com",<br/>  "securityhub.amazonaws.com",<br/>  "ram.amazonaws.com",<br/>  "tagpolicies.tag.amazonaws.com"<br/>]</pre> | no |

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
