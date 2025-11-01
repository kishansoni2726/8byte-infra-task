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

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    example-20251028135602095400000001 = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = var.node_group_instance_types

      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      desired_size   = var.node_group_desired_size
      disk_size      = 30
      force_update_version = true


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