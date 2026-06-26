module "org" {
  source = "git::https://github.com/Coalfire-CF/terraform-aws-organization.git?ref=vx.x.x"

  providers = {
    aws = aws.root
  }

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

  account_number    = local.root_account_id
  create_cloudtrail = var.create_cloudtrail
  is_organization   = var.is_organization
  organization_id   = var.organization_id
}

## Full Delegate Admin Policy - needed for GuardDuty, Config, Security Hub ##
resource "aws_organizations_resource_policy" "admin_delegate" {

  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DelegatingAdmin",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:${local.partition}:iam::${local.mgmt_account_id}:root"
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