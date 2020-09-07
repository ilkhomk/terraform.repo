# terraform-iaac-2020
## Usage of this module 
### Create environments.tfvars file  with the following content

```
region                      =   "us-east-1"
cidr_block                  =   "10.0.0.0/16"

public_cidr1                =   "10.0.101.0/24"
public_cidr2                =   "10.0.102.0/24"
public_cidr3                =   "10.0.103.0/24"

private_cidr1               =   "10.0.1.0/24"
private_cidr2               =   "10.0.2.0/24"
private_cidr3               =   "10.0.3.0/24"

tags    =   {
    Name                    =   "VPC_Project"
    Environment             =   "Dev"
    Team                    =   "DevOps"
    Department              =   "IT"
    Bill                    =   "CFO"
    Quarter                 =   "3"
   }
```
###  Please add the following code into module.tf file
```
module "wordpress" {
    source                      =   "./class5"
    region                      =   "${var.region}"
    cidr_block                  =   "${var.cidr_block}"       
    public_cidr1                =   "${var.public_cidr1}"   
    public_cidr2                =   "${var.public_cidr2}"    
    public_cidr3                =   "${var.public_cidr3}"    
    private_cidr1               =   "${var.private_cidr1}"      
    private_cidr2               =   "${var.private_cidr2}"     
    private_cidr3               =   "${var.private_cidr3}"      
    tags                        =   "${var.tags}"
}

```

### Please run 
``` 
terraform apply -var-file environment.tfvars