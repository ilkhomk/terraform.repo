### This module has interpolations

#### use below values for subnets 
```
	For Public Subnet 1 use  "${data.terraform_remote_state.main.outputs.public_subnet1}",
    For Public Subnet 2 use  "${data.terraform_remote_state.main.outputs.public_subnet2}",
    For Public Subnet 3 use  "${data.terraform_remote_state.main.outputs.public_subnet3}",

```