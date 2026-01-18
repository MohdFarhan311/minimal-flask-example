############################
# Default VPC
############################
data "aws_vpc" "default" {
  default = true
}

############################
# EKS-SUPPORTED SUBNETS ONLY
############################
data "aws_subnets" "eks" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c",
      "us-east-1d",
      "us-east-1f"
    ]
  }
}

############################
# EKS CLUSTER
############################
resource "aws_eks_cluster" "this" {
  name     = "farhan-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = data.aws_subnets.eks.ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

############################
# EKS NODE GROUP
############################
resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = data.aws_subnets.eks.ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}
