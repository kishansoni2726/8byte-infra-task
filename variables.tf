variable "project" {
  type        = string
  description = "Project Title (yesmust use lowercase letters)"
  default     = "node-app-demo"
}

variable "environment" {
  type    = string
  default = "prod"
}
variable "region" {
  type        = string
  description = "Default Region for Project"
  default     = "ap-south-1"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

}

variable "eks_cluster_version" {
  type    = string
  default = "1.30"
}
variable "node_group_instance_types" {
  type    = list(string)
  default = ["t3.micro"]
}

variable "node_group_min_size" {
  type    = number
  default = 2
}
variable "node_group_max_size" {
  type    = number
  default = 6
}
variable "node_group_desired_size" {
  type    = number
  default = 3
}

variable "app_image" {
  type    = string
  default = "nginx:stable"
}
variable "app_replicas" {
  type    = number
  default = 3
}
variable "app_container_port" {
  type    = number
  default = 80
}

variable "db_instance_class" {
  type        = string
  description = "Instance Type"
  default     = "db.t3.medium"
}

variable "db_username" {
  type        = string
  description = "Database Username"
  default     = "dbuser1"
}

variable "db_password" {
  type        = string
  description = "Database Password"
  default     = "password"
}

