![Coalfire](coalfire_logo.png)

> [!WARNING]
> Module is still in Minimal Viable Product (MVP) state.  
> Actions to lift out of MVP status:  
> - Peer deployment and/or review of module & companion configuration role.

# AWS Organizations Terraform Module

# terraform-aws-organization

## Description

This module sets up an AWS Organization with org-level services, including GuardDuty, Security Hub, AWS Config, and Cloudtrail.

Note: The AWS Organizations pack may not need to be deployed if the client already has a Root Organization Root account set up in the GovCloud environment.

FedRAMP Compliance: Moderate, High

## Architecture

Architecture diagram coming soon. 

## Dependencies

- AWS Account Setup: https://github.com/Coalfire-CF/terraform-aws-account-setup
- Region Setup

## Environment Setup

```hcl
- Download and install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- Log into the AWS Console and [create AWS CLI Credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

- Configure the named profile used for the project, such as `aws configure --profile example-mgmt`
```

## Tree
```
.
|-- CONTRIBUTING.md
|-- License.md
|-- README.md
|-- coalfire_logo.png
|-- update-readme-tree.sh
```
## Resource List

A high-level list of resources created as a part of this module:

- AWS Organization with organization level services (e.g. CloudTrail)
- AWS Organization Policy 
- IAM Role and Policy 

## Related Repositories

AWS resources that can be used with AWS Organizations: 
- AWS Config: https://github.com/Coalfire-CF/terraform-aws-config
- AWS GuardDuty: https://github.com/Coalfire-CF/terraform-aws-guardduty
- AWS Security Hub: https://github.com/Coalfire-CF/terraform-aws-security-hub
- AWS Control Tower: https://github.com/Coalfire-CF/terraform-aws-control-tower

#To do: Add narrative on when to use??

## Code Updates

- May 2025 - README Updates


## Deployment

This section details how an engineer should go about deploying its resources, any key dependencies, and/or deployment configurations.

Example:

1. Navigate to the Terraform project and create a parent directory in the upper level code, for example:

    ```hcl
    ../aws/terraform/{REGION}/management-account/example
    ```

   If multi-account management plane:

    ```hcl
    ../aws/terraform/{REGION}/{ACCOUNT_TYPE}-mgmt-account/example
    ```

2. Create a new branch. The branch name should provide a high level overview of what you're working on. 

3. Create a properly defined main.tf file via the template found under 'Usage' while adjusting tfvars as needed. Note that many provided variables are outputs from other modules. Example parent directory:

   ```hcl
   ├── Example/
   │   ├── prefix.auto.tfvars
   │   ├── userdata/
   │   │   ├── script.sh
   │   ├── data.tf
   │   ├── locals.tf
   │   ├── main.tf
   │   ├── outputs.tf
   │   ├── providers.tf
   │   ├── README.md
   │   ├── remote-data.tf
   │   ├── required-providers.tf
   │   ├── userdata.tf
   │   ├── tstate.tf
   │   ├── variables.tf
   │   ├── ...
   ```

4. Change directories to the `terraform-aws-organization` directory.

5. Ensure that the `prefix.auto.tfvars` variables are correct (especially the profile) or create a new tfvars file with the correct variables

6. Customize code to meet requirements

7. From the `terraform-aws-organization` directory run, initialize the Terraform working directory:
   ```hcl
   terraform init
   ```

8. Standardized formatting in code:
   ```hcl
   terraform fmt
   ```

9. Optional: Ensure proper syntax and "spell check" your code:
   ```hcl
   terraform validate
   ```

10. Create an execution plan and verify everything looks correct:
   ```hcl
   terraform plan
   ```

11. Apply the configuration:
   ```hcl
   terraform apply
   ```

## Usage

Below is an example for how to call the module below with generic variables:

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
    "member.org.stacksets.cloudformation.amazonaws.com",
    "sso.amazonaws.com",
    "ssm.amazonaws.com",
    "servicecatalog.amazonaws.com",
    "guardduty.amazonaws.com",
    "securityhub.amazonaws.com",
    "ram.amazonaws.com",
    "tagpolicies.tag.amazonaws.com"
  ]
  org_account_name      = "${var.resource_prefix}-org-root"
  enabled_policy_types  = ["SERVICE_CONTROL_POLICY"]
  create_org_cloudtrail = var.create_org_cloudtrail
  feature_set           = "ALL"
  aws_region            = var.aws_region
  default_aws_region    = var.default_aws_region
  resource_prefix       = var.resource_prefix

  account_number    = var.account_number
  create_cloudtrail = var.create_cloudtrail
  is_organization   = var.is_organization
  organization_id   = var.organization_id
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

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_account_setup"></a> [account\_setup](#module\_account\_setup) | github.com/Coalfire-CF/terraform-aws-account-setup | v0.0.42 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.org-trail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_iam_role.aws_config_org_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.organization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.controltower_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_number"></a> [account\_number](#input\_account\_number) | The AWS account number resources are being deployed into | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | n/a | yes |
| <a name="input_create_cloudtrail"></a> [create\_cloudtrail](#input\_create\_cloudtrail) | Whether or not to create cloudtrail resources | `bool` | n/a | yes |
| <a name="input_create_org_cloudtrail"></a> [create\_org\_cloudtrail](#input\_create\_org\_cloudtrail) | True/False statement whether to enable AWS Cloudtrail in the Organization | `bool` | n/a | yes |
| <a name="input_default_aws_region"></a> [default\_aws\_region](#input\_default\_aws\_region) | The default AWS region to create resources in | `string` | n/a | yes |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | List of Organizations policy types to enable in the Organization Root. Organization must have feature\_set set to ALL. For additional information about valid policy types (e.g., AISERVICES\_OPT\_OUT\_POLICY, BACKUP\_POLICY, SERVICE\_CONTROL\_POLICY, and TAG\_POLICY) | `list(string)` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_feature_set"></a> [feature\_set](#input\_feature\_set) | Feature set to be used with Org and member accounts Specify ALL(default) or CONSOLIDATED\_BILLING. | `string` | `"ALL"` | no |
| <a name="input_is_organization"></a> [is\_organization](#input\_is\_organization) | Whether or not to enable certain settings for AWS Organization | `bool` | n/a | yes |
| <a name="input_org_account_name"></a> [org\_account\_name](#input\_org\_account\_name) | value to be used for the org account name | `string` | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | AWS Organization ID | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_service_access_principals"></a> [service\_access\_principals](#input\_service\_access\_principals) | List of AWS Service Access Principals that you want to enable for organization integration | `list(string)` | <pre>[<br/>  "cloudtrail.amazonaws.com",<br/>  "config.amazonaws.com",<br/>  "config-multiaccountsetup.amazonaws.com",<br/>  "member.org.stacksets.cloudformation.amazonaws.com",<br/>  "sso.amazonaws.com",<br/>  "ssm.amazonaws.com",<br/>  "servicecatalog.amazonaws.com",<br/>  "guardduty.amazonaws.com",<br/>  "controltower.amazonaws.com",<br/>  "securityhub.amazonaws.com",<br/>  "ram.amazonaws.com",<br/>  "tagpolicies.tag.amazonaws.com"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accounts"></a> [accounts](#output\_accounts) | List of org accounts including master |
| <a name="output_additional_kms_key_arns"></a> [additional\_kms\_key\_arns](#output\_additional\_kms\_key\_arns) | n/a |
| <a name="output_additional_kms_key_ids"></a> [additional\_kms\_key\_ids](#output\_additional\_kms\_key\_ids) | n/a |
| <a name="output_backup_kms_key_arn"></a> [backup\_kms\_key\_arn](#output\_backup\_kms\_key\_arn) | n/a |
| <a name="output_backup_kms_key_id"></a> [backup\_kms\_key\_id](#output\_backup\_kms\_key\_id) | n/a |
| <a name="output_cloudwatch_kms_key_arn"></a> [cloudwatch\_kms\_key\_arn](#output\_cloudwatch\_kms\_key\_arn) | n/a |
| <a name="output_cloudwatch_kms_key_id"></a> [cloudwatch\_kms\_key\_id](#output\_cloudwatch\_kms\_key\_id) | n/a |
| <a name="output_config_kms_key_arn"></a> [config\_kms\_key\_arn](#output\_config\_kms\_key\_arn) | n/a |
| <a name="output_config_kms_key_id"></a> [config\_kms\_key\_id](#output\_config\_kms\_key\_id) | n/a |
| <a name="output_dynamo_kms_key_arn"></a> [dynamo\_kms\_key\_arn](#output\_dynamo\_kms\_key\_arn) | n/a |
| <a name="output_dynamo_kms_key_id"></a> [dynamo\_kms\_key\_id](#output\_dynamo\_kms\_key\_id) | n/a |
| <a name="output_dynamodb_table_name"></a> [dynamodb\_table\_name](#output\_dynamodb\_table\_name) | n/a |
| <a name="output_ebs_kms_key_arn"></a> [ebs\_kms\_key\_arn](#output\_ebs\_kms\_key\_arn) | n/a |
| <a name="output_ebs_kms_key_id"></a> [ebs\_kms\_key\_id](#output\_ebs\_kms\_key\_id) | n/a |
| <a name="output_eks_node_role_arn"></a> [eks\_node\_role\_arn](#output\_eks\_node\_role\_arn) | n/a |
| <a name="output_eks_node_role_name"></a> [eks\_node\_role\_name](#output\_eks\_node\_role\_name) | n/a |
| <a name="output_lambda_kms_key_arn"></a> [lambda\_kms\_key\_arn](#output\_lambda\_kms\_key\_arn) | n/a |
| <a name="output_lambda_kms_key_id"></a> [lambda\_kms\_key\_id](#output\_lambda\_kms\_key\_id) | n/a |
| <a name="output_master_account_id"></a> [master\_account\_id](#output\_master\_account\_id) | Master account ID |
| <a name="output_nfw_kms_key_arn"></a> [nfw\_kms\_key\_arn](#output\_nfw\_kms\_key\_arn) | n/a |
| <a name="output_nfw_kms_key_id"></a> [nfw\_kms\_key\_id](#output\_nfw\_kms\_key\_id) | n/a |
| <a name="output_org_id"></a> [org\_id](#output\_org\_id) | Organization ID |
| <a name="output_packer_iam_role_arn"></a> [packer\_iam\_role\_arn](#output\_packer\_iam\_role\_arn) | n/a |
| <a name="output_packer_iam_role_name"></a> [packer\_iam\_role\_name](#output\_packer\_iam\_role\_name) | n/a |
| <a name="output_rds_kms_key_arn"></a> [rds\_kms\_key\_arn](#output\_rds\_kms\_key\_arn) | n/a |
| <a name="output_rds_kms_key_id"></a> [rds\_kms\_key\_id](#output\_rds\_kms\_key\_id) | n/a |
| <a name="output_s3_access_logs_arn"></a> [s3\_access\_logs\_arn](#output\_s3\_access\_logs\_arn) | n/a |
| <a name="output_s3_access_logs_id"></a> [s3\_access\_logs\_id](#output\_s3\_access\_logs\_id) | n/a |
| <a name="output_s3_backups_arn"></a> [s3\_backups\_arn](#output\_s3\_backups\_arn) | n/a |
| <a name="output_s3_backups_id"></a> [s3\_backups\_id](#output\_s3\_backups\_id) | n/a |
| <a name="output_s3_cloudtrail_arn"></a> [s3\_cloudtrail\_arn](#output\_s3\_cloudtrail\_arn) | n/a |
| <a name="output_s3_cloudtrail_id"></a> [s3\_cloudtrail\_id](#output\_s3\_cloudtrail\_id) | n/a |
| <a name="output_s3_config_arn"></a> [s3\_config\_arn](#output\_s3\_config\_arn) | n/a |
| <a name="output_s3_config_id"></a> [s3\_config\_id](#output\_s3\_config\_id) | n/a |
| <a name="output_s3_elb_access_logs_arn"></a> [s3\_elb\_access\_logs\_arn](#output\_s3\_elb\_access\_logs\_arn) | n/a |
| <a name="output_s3_elb_access_logs_id"></a> [s3\_elb\_access\_logs\_id](#output\_s3\_elb\_access\_logs\_id) | n/a |
| <a name="output_s3_fedrampdoc_arn"></a> [s3\_fedrampdoc\_arn](#output\_s3\_fedrampdoc\_arn) | n/a |
| <a name="output_s3_fedrampdoc_id"></a> [s3\_fedrampdoc\_id](#output\_s3\_fedrampdoc\_id) | n/a |
| <a name="output_s3_installs_arn"></a> [s3\_installs\_arn](#output\_s3\_installs\_arn) | n/a |
| <a name="output_s3_installs_id"></a> [s3\_installs\_id](#output\_s3\_installs\_id) | n/a |
| <a name="output_s3_kms_key_arn"></a> [s3\_kms\_key\_arn](#output\_s3\_kms\_key\_arn) | n/a |
| <a name="output_s3_kms_key_id"></a> [s3\_kms\_key\_id](#output\_s3\_kms\_key\_id) | n/a |
| <a name="output_s3_tstate_bucket_name"></a> [s3\_tstate\_bucket\_name](#output\_s3\_tstate\_bucket\_name) | n/a |
| <a name="output_sm_kms_key_arn"></a> [sm\_kms\_key\_arn](#output\_sm\_kms\_key\_arn) | n/a |
| <a name="output_sm_kms_key_id"></a> [sm\_kms\_key\_id](#output\_sm\_kms\_key\_id) | n/a |
| <a name="output_sns_kms_key_arn"></a> [sns\_kms\_key\_arn](#output\_sns\_kms\_key\_arn) | n/a |
| <a name="output_sns_kms_key_id"></a> [sns\_kms\_key\_id](#output\_sns\_kms\_key\_id) | n/a |
<!-- END_TF_DOCS -->

## Contributing

[Start Here](CONTRIBUTING.md)

## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)

## Contact Us

[Coalfire](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.