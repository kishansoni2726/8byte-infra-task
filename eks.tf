#############################################
# EKS Cluster (Control Plane only)
#############################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.8"

  name               = "${var.project}-eks-cluster"
  cluster_version    = "1.31"
  enable_irsa        = true
  create_node_groups = false # disable internal node groups

  vpc_id                   = aws_vpc.main.id
  subnet_ids               = aws_subnet.private_subnets[*].id
  control_plane_subnet_ids = aws_subnet.private_subnets[*].id

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  addons = {
    coredns = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
  }

  tags = {
    Terraform = "true"
    Project   = var.project
  }
}

#############################################
# EKS Node Group (Managed independently)
#############################################
resource "aws_eks_node_group" "example" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "${var.project}-node-group"
  node_role_arn   = module.eks.node_group_iam_role_arn
  subnet_ids      = aws_subnet.private_subnets[*].id

  ami_type       = "AL2023_x86_64_STANDARD"
  instance_types = var.node_group_instance_types
  disk_size      = 20

  scaling_config {
    desired_size = var.node_group_desired_size
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size,
      instance_types,
      tags,
    ]
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Terraform = "true"
    Project   = var.project
  }

  depends_on = [module.eks]
}

#############################################
# Data Sources for Kubernetes Provider
#############################################
data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}
