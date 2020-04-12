variable "pgdb_name" {
  type        = string
  description = "Name of cluster, used deployment wide"
}

variable "rds_instance_class" {
  type        = string
  default     = "db.t3.medium"
  description = "AWS DB instance class. The least to run it fine. "
}

variable "pgdb_username" {
  type        = string
  description = "Master username for the cluster"
}

variable "pgdb_password" {
  type        = string
  description = "Master password for the cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC to place the Postgresql cluster in"
}

variable "ingress_blocks" {
  type        = list
  description = "CIDR blocks allowed to communicate into the cluster on 5432"
}

variable "subnet_ids" {
  type        = list
  description = "VPC subnet IDs"
}

variable "family" {
  type        = string
  default     = "aurora-postgresql10"
  description = "Aurora Postgresql 10"
}

variable "instance_count" {
  type        = string
  default     = "3"
  description = "Number of instances to create in cluster"
}

variable "skip_final" {
  type        = string
  description = "Should final snapshot be skipped"
  default     = "true"
}

variable "backup_retention" {
  type        = string
  description = "Backup retention period in days"
  default     = "5"
}

variable "engine" {
  type        = string
  description = "Database Engine"
  default     = "aurora-postgresql"
}

variable "engine_version" {
  type        = string
  description = "Database Engine version"
  default     = "10.7"
}

variable "create_monitoring_iam_role" {
  type        = bool
  description = "Whether to automatically create the IAM role required for enhanced monitoring. Default: false."
  default     = false
}
