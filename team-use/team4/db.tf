provider "aws" {
	region = "us-east-1"
}



resource "aws_db_subnet_group" "db" {
	name = "db"
	subnet_ids = [
	"${data.terraform_remote_state.main.outputs.public_subnet1}",
    "${data.terraform_remote_state.main.outputs.public_subnet2}",
    "${data.terraform_remote_state.main.outputs.public_subnet3}",
	]
}
