module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source = "./modules/eks"

  project_private_subnet_ids = module.vpc.project_private_subnet_ids
  cluster_name               = "project-cluster"
  cluster_role_arn           = "arn:aws:iam::123456789012:role/project-eks-cluster-role"
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = "project-repo"
}

module "iam" {
  source = "./modules/iam"

  user_name = "project-user"
}
