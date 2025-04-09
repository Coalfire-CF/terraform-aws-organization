data "aws_iam_policy_document" "preventIAMChanges" {
  statement {
    effect    = "Deny"
    resources = ["*"]

    actions = [
      "iam:AddUserToGroup",
      "iam:AttachRolePolicy",
      "iam:AttachUserPolicy",
      "iam:CreateAccessKey",
      "iam:CreateLoginProfile",
      "iam:CreatePolicyVersion",
      "iam:CreateRole",
      "iam:CreateUser",
      "iam:DeleteRole",
      "iam:DeleteRolePermissionsBoundary",
      "iam:DeleteRolePolicy",
      "iam:DeleteUserPermissionsBoundary",
      "iam:DeleteUserPolicy",
      "iam:DetachRolePolicy",
      "iam:PassRole",
      "iam:PutRolePermissionsBoundary",
      "iam:PutRolePolicy",
      "iam:PutUserPermissionsBoundary",
      "iam:SetDefaultPolicyVersion",
      "iam:UpdateAssumeRolePolicy",
      "iam:UpdateLoginProfile",
      "iam:UpdateLoginProfile",
      "iam:UpdateRole",
      "iam:UpdateRoleDescription",
      "sts:AssumeRole",
    ]

    condition {
      test     = "ArnNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/[ALLOWED_ROLE_NAME]"] # only admin users can change - to prevent any powerusers from having the rights
    }
  }
}