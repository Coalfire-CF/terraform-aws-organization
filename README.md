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

## Post Deployment Configuration

WIP - Include the corresponding post deployment confluence page if applicable. Example:

```hcl
Please refer to the corresponding internal confluence page for this module for post deployment configuration found [here](https://coalfire.atlassian.net/wiki/spaces/CEHOME/pages/3125412613/1.+BurpSuite+Professional+Configuration).
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Contributing

[Start Here](CONTRIBUTING.md)

## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)

## Contact Us

[Coalfire](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.