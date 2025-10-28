resource "aws_docdb_subnet_group" "docdb_subnets" {
  name       = "${var.project}-docdb-subnet-group"
  subnet_ids = aws_subnet.private_subnets[*].id
}

resource "aws_docdb_cluster" "mongo_cluster" {
  cluster_identifier       = "${var.project}-mongo-cluster"
  engine                   = "docdb"
  master_username          = var.db_username
  master_password          = var.db_password
  db_subnet_group_name     = aws_docdb_subnet_group.docdb_subnets.name
  vpc_security_group_ids   = [aws_security_group.rds_sg.id, aws_security_group.eks_nodes_sg.id]
  skip_final_snapshot      = true
  apply_immediately        = true

  tags = {
    Name = "${var.project}-mongo-cluster"
  }
}

resource "aws_docdb_cluster_instance" "mongo_instance" {
  count              = 1
  identifier         = "${var.project}-mongo-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.mongo_cluster.id
  instance_class     = var.db_instance_class
  apply_immediately  = true

  tags = {
    Name = "${var.project}-mongo-instance"
  }
}
