data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "kubernetes" {
  host = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.cluster.token
  load_config_file = false
  version = "~> 1.9"
}

module "my-cluster" {
  source = "terraform-aws-modules/eks/aws"
   version = "12.0.0"
  cluster_name = "my-cluster"
  cluster_version = "1.14"
  subnets = ["subnet-01fd890eaff2139b7", "subnet-06e2b411c295d270d", "subnet-00f8f8482e906ba1f"]
  vpc_id = "vpc-07653ca7ae9fba593"
  worker_groups = [{
    instance_type = "m4.large"
    asg_max_size = 5
    asg_min_size = 3
    }
  ]
}
