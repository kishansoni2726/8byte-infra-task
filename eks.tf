module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.project}-eks-cluster"
  kubernetes_version = "1.33"

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = aws_vpc.main.id
  subnet_ids               = aws_subnet.private_subnets[*].id
  control_plane_subnet_ids = aws_subnet.private_subnets[*].id

  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = var.node_group_instance_types

      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      desired_size   = var.node_group_desired_size

      lifecycle = {
        ignore_changes = [
          desired_size,
          scaling_config[0].desired_size,
          tags,
        ]
      }
    }
  }

  tags = {
    Terraform = "true"
  }
}

# Data sources required for Kubernetes provider authentication
data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}
