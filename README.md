![Coalfire](coalfire_logo.png)

## ACE AWS Organizations Terraform Module

## Description
This module sets up an AWS Organization with org-level services, including Guard Duty, Security Hub, AWS Config, and Cloudtrail.

FedRAMP Compliance: Moderate, High

## Resource List

A high-level list of resources created as a part of this module.

- AWS Organization with org level services
  - Cloudtrail
- AWS Organization policy
- IAM role and policy
- KMS keys and typically required IAM permissions for commonly used services (S3, DynamoDB, Config).
- S3 buckets (ORG CloudTrail, Config, Backups, State)

## Usage

Example for how to call the module below with generic variables:

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
    "backup.amazonaws.com",
    "config.amazonaws.com",
    "cloudtrail.amazonaws.com",
    "guardduty.amazonaws.com",
    "malware-protection.guardduty.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "ram.amazonaws.com",
    "securityhub.amazonaws.com",
    "servicecatalog.amazonaws.com",
    "ssm.amazonaws.com",
    "sso.amazonaws.com",
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

For org deployments where a delegated admin is required/needed:
```
module "org" {
  ## update source once branch is merged into main
  source = "git::https://github.com/Coalfire-CF/terraform-aws-organization.git?ref=fa-aws-pakpt-update"

  service_access_principals = [
    "cloudtrail.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "sso.amazonaws.com",
    "ssm.amazonaws.com",
    "servicecatalog.amazonaws.com",
    "guardduty.amazonaws.com",
    "malware-protection.guardduty.amazonaws.com",
    "securityhub.amazonaws.com",
    "ram.amazonaws.com",
    "tagpolicies.tag.amazonaws.com",
    "config.amazonaws.com",
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

## Full Delegate Admin Policy ##
resource "aws_organizations_resource_policy" "admin_delegate" {

  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DelegatingAdmin",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:${local.partition}:iam::${local.mgmt_plane_account_id}:root"
      },
      "Action": [
        "organizations:CreatePolicy",
        "organizations:UpdatePolicy",
        "organizations:DeletePolicy",
        "organizations:AttachPolicy",
        "organizations:DetachPolicy",
        "organizations:EnablePolicyType",
        "organizations:DisablePolicyType",
        "organizations:DescribeOrganization",
        "organizations:DescribeOrganizationalUnit",
        "organizations:DescribeAccount",
        "organizations:DescribePolicy",
        "organizations:DescribeEffectivePolicy",
        "organizations:ListRoots",
        "organizations:ListOrganizationalUnitsForParent",
        "organizations:ListParents",
        "organizations:ListChildren",
        "organizations:ListAccounts",
        "organizations:ListAccountsForParent",
        "organizations:ListPolicies",
        "organizations:ListPoliciesForTarget",
        "organizations:ListTargetsForPolicy",
        "organizations:ListTagsForResource"
      ],
      "Resource": "*"
    }
  ]
}
EOF
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

## Environment Setup

Establish a secure connection to the Management AWS account used for the build:

```hcl
IAM user authentication:

- Download and install the AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Log into the AWS Console and create AWS CLI Credentials (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
- Configure the named profile used for the project, such as 'aws configure --profile example-mgmt'

SSO-based authentication (via IAM Identity Center SSO):

- Login to the AWS IAM Identity Center console, select the permission set for MGMT, and select the 'Access Keys' link.
- Choose the 'IAM Identity Center credentials' method to get the SSO Start URL and SSO Region values.
- Run the setup command 'aws configure sso --profile example-mgmt' and follow the prompts.
- Verify you can run AWS commands successfully, for example 'aws s3 ls --profile example-mgmt'.
- Run 'export AWS_PROFILE=example-mgmt' in your terminal to use the specific profile and avoid having to use '--profile' option.
```

## Deployment

1. Navigate to the Terraform project and create a parent directory in the upper level code, for example:

    ```hcl
    ../{CLOUD}/terraform/{REGION}/management-account/example
    ```
   If multi-account management plane:

    ```hcl
    ../{CLOUD}/terraform/{REGION}/{ACCOUNT_TYPE}-mgmt-account/example
    ```

2. Create a properly defined main.tf file via the template found under 'Usage' while adjusting 'auto.tfvars' as needed. Example parent directory:

    ```hcl
     ├── Example/
     │   ├── example.auto.tfvars   
     │   ├── main.tf
     │   ├── outputs.tf
     │   ├── providers.tf
     │   ├── required-providers.tf
     │   ├── remote-data.tf
     │   ├── variables.tf 
     │   ├── ...
     ```
   Example 'auto.tfvars':
     ```hcl
     aws_region         = "us-gov-west-1"
     default_aws_region = "us-gov-west-1"
     account_number     = "01010101010101"
     resource_prefix    = "test-org"
     create_cloudtrail = true # This is always set to true to create the cloudtrail S3 bucket using account setup PAK

     # Set both to FALSE on first apply, then run again with TRUE to apply the org cloudtrail and organization ID to policies
     create_org_cloudtrail = false
     is_organization       = false

     # Uncomment on second run with ORG ID obtained from the output of the first run
     #organization_id      = ""
     ```

3. Configure Terraform local backend and stage remote backend. For the first run, the entire contents of the 'remote-data.tf' file must be commented out with terraform local added to facilitate local state setup, like below:
   ```hcl
   //terraform {
   //  backend "s3" {
   //    bucket         = "{resource_prefix}-{region}-tf-state"
   //    region         = "{region}"
   //    key            = "{resource_prefix}-{region}-org-setup.tfstate"
   //    encrypt        = true
   //    use_lockfile   = true
   //  }
   //}
   terraform {
   backend "local"{}
   }
   ```
   
4. Initialize the Terraform working directory:
   ```hcl
   terraform init
   ```
   Create an execution plan and verify the resources being created:
   ```hcl
   terraform plan
   ```
   Apply the configuration:
   ```hcl
   terraform apply
   ```

5. After the deployment has succeeded, uncomment the contents of 'remote-state.tf' and remove the terraform local code block.

6. Follow the directions on the example 'auto.tfvars' previously provided to create cloudtrail and update policies. You will need to update 'create_org_cloudtrail' and 'is_organization' to 'true' while uncommenting and adding 'organization_id' value.

7. Create an execution plan and verify the resources being created:
   ```hcl
   terraform plan
   ```
   Apply the configuration:
   ```hcl
   terraform apply
   ```

8. Run 'terraform init -migrate-state' and follow the prompts to migrate the local state file to the appropriate S3 bucket in the AWS Master Payer account.

## Post Deployment Configuration
```
Ensure you invite other AWS accounts to the organization, then accept the invitations in each child account.
```
```
Depending on the context of the build out of this module, the role OrganizationAccountAccessRole may need to be manually created in each child project. The trust relationship of this role must include other AWS accounts that use cross project resource provisioning. See reference https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create-cross-account-role.html
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
| <a name="output_cloudtrail_arn"></a> [cloudtrail\_arn](#output\_cloudtrail\_arn) | n/a |
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
| <a name="output_s3_cloudtrail_bucket_arn"></a> [s3\_cloudtrail\_bucket\_arn](#output\_s3\_cloudtrail\_bucket\_arn) | n/a |
| <a name="output_s3_cloudtrail_bucket_name"></a> [s3\_cloudtrail\_bucket\_name](#output\_s3\_cloudtrail\_bucket\_name) | n/a |
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

[Relative or absolute link to contributing.md](CONTRIBUTING.md)


## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)


## Coalfire Pages

[Absolute link to any relevant Coalfire Pages](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.