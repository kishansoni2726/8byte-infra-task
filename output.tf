output "vpc_id" {
  value = aws_vpc.main.id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "mongo_endpoint" {
  value = "${aws_docdb_cluster.mongo_cluster.endpoint}:27017"
}
