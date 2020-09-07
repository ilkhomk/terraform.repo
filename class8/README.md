# Repo for building EKS Cluster
### Requirement 0.12.19
Create a file called module.tf 
```
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


```

## Create a file output.tf 
```
output "cluster_id" {
    value = "${module.my-cluster.cluster_id}"
}

output "cluster_arn" {
    value = "${module.my-cluster.cluster_arn}"
}

output "cluster_version" {
    value = "${module.my-cluster.cluster_version}"
}

output "cluster_security_group_id" {
    value = "${module.my-cluster.cluster_security_group_id}"
}

output "workers_asg_names" {
    value = "${module.my-cluster.workers_asg_names}"
}
```


### Run the following commands
```
terraform init 
terraform apply
```