resource "aws_eks_cluster" "project_cluster" {
	name     = var.cluster_name
	role_arn = var.cluster_role_arn

	vpc_config {
		subnet_ids = var.project_private_subnet_ids
	}
}

resource "aws_eks_node_group" "project_node_group" {
    cluster_name    = aws_eks_cluster.project_cluster.name
    node_group_name = "${var.cluster_name}-node-group"
    node_role_arn   = var.cluster_role_arn
    subnet_ids      = var.project_private_subnet_ids

    scaling_config {
        desired_size = 2
        max_size     = 3
        min_size     = 1
    }
}


