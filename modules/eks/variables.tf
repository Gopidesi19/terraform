variable "cluster_name" {
	type = string
}

variable "cluster_role_arn" {
	type = string
}

variable "project_private_subnet_ids" {
	type = list(string)
}
