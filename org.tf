resource "aws_organizations_organization" "org" {
  aws_service_access_principals = var.service_access_principals

  feature_set = var.feature_set

  #enabled_policy_types = var.enabled_policy_types # I want to implement this based off a check of feature_set - if not set to ALL then this is null.
}

resource "aws_organizations_delegated_administrator" "delegated_admin" {
  for_each = var.delegated_admin_account_id
  account_id        = each.value
  service_principal = var.delegated_service_principal[each.index]
}

resource "aws_organizations_account" "account" {
  for_each  = var.aws_new_member_account_email
  name  = var.aws_new_member_account_name[each.index]
  email = each.value
}

resource "aws_organizations_policy" "scp" {
  provider = aws.root
  content = data.aws_iam_policy_document.scp.json
  name = "FedModGovSCP"
}

resource "aws_organizations_policy_attachment" "scp" {
  provider = aws.root
  policy_id = aws_organizations_policy.scp.id
  target_id = aws_organizations_organization.org.id
}

data "aws_iam_policy_document" "scp" {
  ## Enforce usage of IPAM for creating a VPC
  statement {
    effect = "Deny"
    actions = [
      "ec2:CreateVpc",
      "ec2:AssociateVpcCidrBlock"]
    resources = [
      "arn:${var.partition}:ec2:*:*:vpc/*"]
    condition {
      test = "Null"
      values = [
        "true"]
      variable = "ec2:Ipv4IpamPoolId"
    }
  }

  ## Prevent member accounts from leaving Org
  statement {
    effect = "Deny"
    actions = ["organizations:LeaveOrganization"]
    resources = ["*"]
  }

  ## Enforce enabling of flowlogs for VPC
  statement {
    effect = "Deny"
    actions = ["ec2:DeleteFlowLogs"]
    resources = ["*"]
  }

  ## Enforce EC2 tagging for Ansible inventory
  statement {
    effect = "Deny"
    actions = ["ec2:RunInstances"]
    resources = [
      "arn:${var.partition}:ec2:*:*:instance/*",
      "arn:${var.partition}:ec2:*:*:volume/*"
    ]
    condition {
      test = "Null"
      values = ["true"]
      variable = "aws:RequestTag/OSType"
    }
  }

  ## Deny changing of security tooling IAM role
  statement {
    effect = "Deny"
    actions = ["iam:DeleteRole", "iam:DeleteRolePolicy"]
    resources = ["arn:${var.partition}:iam::*:role/ops-stack-security-tooling"]
    condition {
      test = "StringNotLike"
      values = ["arn:${var.partition}:iam::*:role/tfadmin"]
      variable = "aws:PrincipalARN"
    }
  }
}