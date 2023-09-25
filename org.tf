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

resource "aws_organizations_organizational_unit" "ou" {
  for_each = var.ou_creation_info
  name      = ou_creation_info.value["ou_name"]
  parent_id = ou_creation_info.value["ou_parent_id"]
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

resource "aws_organizations_resource_policy" "org_resource_policy" {
  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:${var.partition}:iam::${aws_organizations_organization.org.roots[0].id}:root"
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
      "Resource": [
        "arn:${var.partition}:organizations::${aws_organizations_organization.org.roots[0].id}:ou/${aws_organizations_organizational_unit.ou[*].id}/*"]
    }
  ]
}
EOF
}