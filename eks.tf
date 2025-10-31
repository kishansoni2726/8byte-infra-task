module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 22.0"

  name               = "${var.project}-eks-cluster"
  kubernetes_version = "1.33"

  vpc_id                   = aws_vpc.main.id
  subnet_ids               = aws_subnet.private_subnets[*].id
  control_plane_subnet_ids = aws_subnet.private_subnets[*].id

  endpoint_public_access                  = true
  enable_cluster_creator_admin_permissions = true

  addons = {
    coredns = {}
    kube-proxy = {}
    vpc-cni = { before_compute = true }
    eks-pod-identity-agent = { before_compute = true }
  }

  eks_managed_node_group_defaults = {
    # Prevent re-provisioning when scaling or tweaking small things
    lifecycle = {
      ignore_changes = [
        desired_size,
        scaling_config[0].desired_size,
        instance_types,
        labels,
        taints,
        tags,
      ]
    }
  }

  eks_managed_node_groups = {
    main = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = var.node_group_instance_types

      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size

      capacity_type = "ON_DEMAND"
      labels = { role = "worker" }

      tags = {
        Name = "${var.project}-eks-node-group"
      }
    }
  }

  tags = {
    Terraform = "true"
    Project   = var.project
  }
}

data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}
