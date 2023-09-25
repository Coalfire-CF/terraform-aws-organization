##AWS CONFIG IAM
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "aws_config_org_role" {
  name               = "org-config-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "organization" {
  role       = aws_iam_role.aws_config_org_role.name
  policy_arn = "arn:${var.partition}:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}

### AWS ORG IAM

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