terraform {
  required_version = ">= 0.12.23"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70.0"
    }
  }
}

# Create the AWS role to manage resources on your behalf

data "aws_iam_policy_document" "one_platform_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["accounts.google.com"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test = "StringEquals"
      variable = "accounts.google.com:sub"
      values = [
        "service-${var.gcp_project_number}@gcp-sa-gkemulticloud.iam.gserviceaccount.com",
      
      ]
    }
  }
}
resource "aws_iam_role" "this" {
  name = "${var.anthos_prefix}-anthos-api-role"

  description        = "IAM role for OnePlatform service backend"
  assume_role_policy = data.aws_iam_policy_document.one_platform_assume_role_policy.json

}


# Create a policy and associate it with the previously created role


data "aws_iam_policy_document" "gke_default_policy" {
  statement {
    effect = "Allow"
    actions = [
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateOrUpdateTags",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeleteTags",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateNetworkInterface",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteLaunchTemplate",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeInstances",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
      "ec2:DescribeVpcs",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RunInstances",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "iam:CreateServiceLinkedRole",
      "iam:PassRole",
      "kms:DescribeKey",
      "kms:Encrypt",
    ]
    resources = ["*"]
  }
}


resource "aws_iam_policy" "assume_role_with_web_identity" {
  name = "${var.anthos_prefix}-anthos-api-policy"
  path = "/"

  policy = data.aws_iam_policy_document.gke_default_policy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.assume_role_with_web_identity.arn
}


# Create an instance profile used by your clusters
# control plane for regular cluster operations


data "aws_iam_policy_document" "cp_role_policy" {
  statement {
    effect = "Allow"
    principals {
      service        = "ec2.amazonaws.com"
    }
    actions = ["sts:AssumeRole"] 
  }
}
resource "aws_iam_role" "cp_role" {
  name = "${var.anthos_prefix}-anthos-cp-role"

  description        = "IAM role for control plane"
  assume_role_policy = data.aws_iam_policy_document.cp_role_policy.json

}

# Create the policy for thie role 

data "aws_iam_policy_document" "cp-policy" {
  statement {
    effect = "Allow"
    actions = [
       "iam:CreateServiceLinkedRole",
        "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
        "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:ModifyTargetGroup",
        "elasticloadbalancing:ModifyLoadBalancerAttributes",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:DetachLoadBalancerFromSubnets",
        "elasticloadbalancing:DescribeTargetHealth",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeLoadBalancerPolicies",
        "elasticloadbalancing:DescribeLoadBalancerAttributes",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeleteTargetGroup",
        "elasticloadbalancing:DeleteLoadBalancerListeners",
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:DeleteListener",
        "elasticloadbalancing:CreateTargetGroup",
        "elasticloadbalancing:CreateLoadBalancerPolicy",
        "elasticloadbalancing:CreateLoadBalancerListeners",
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:CreateListener",
        "elasticloadbalancing:ConfigureHealthCheck",
        "elasticloadbalancing:AttachLoadBalancerToSubnets",
        "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
        "elasticloadbalancing:AddTags",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:ModifyVolume",
        "ec2:ModifyInstanceAttribute",
        "ec2:DetachVolume",
        "ec2:DescribeVpcs",
        "ec2:DescribeVolumesModifications",
        "ec2:DescribeVolumes",
        "ec2:DescribeTags",
        "ec2:DescribeSubnets",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeRouteTables",
        "ec2:DescribeRegions",
        "ec2:DescribeLaunchTemplateVersions",
        "ec2:DescribeInstances",
        "ec2:DeleteVolume",
        "ec2:DeleteTags",
        "ec2:DescribeDhcpOptions",
        "ec2:DeleteSnapshot",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteRoute",
        "ec2:CreateVolume",
        "ec2:CreateTags",
        "ec2:CreateSnapshot",
        "ec2:CreateSecurityGroup",
        "ec2:CreateRoute",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AttachVolume",
        "ec2:AttachNetworkInterface",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:DescribeTags",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeAutoScalingGroups",
    ]
    resources = ["*"]
  }
}
## to do , swap resoruce for DB ARN var.db_kms_arn 


resource "aws_iam_policy" "cp_role_with_web_identity" {
  name = "${var.anthos_prefix}-anthos-cp-policy"
  path = "/"

  policy = data.aws_iam_policy_document.cp_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_cp" {
  role       = aws_iam_role.cp_role.name
  policy_arn = aws_iam_policy.cp_role_with_web_identity.arn
}

