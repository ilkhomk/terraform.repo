provider "aws" {
region = "us-east-1"
}


data "aws_ami" "image" {
	most_recent = true
	filter {
	name = "name"
	values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
}
	filter {
	name = "virtualization-type"
	values = ["hvm"]
	}
	owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "as_conf" {
name = "web_config"
image_id = "${data.aws_ami.image.id}"
instance_type = "t2.micro"
}


resource "aws_autoscaling_group" "bar" {
name = "terraform-asg-example"
launch_configuration = "${aws_launch_configuration.as_conf.name}"
vpc_zone_identifier = [
    "${data.terraform_remote_state.main.outputs.private_subnet1}",
    "${data.terraform_remote_state.main.outputs.private_subnet2}",
    "${data.terraform_remote_state.main.outputs.private_subnet3}",

]
min_size = 1
max_size = 2
lifecycle {
create_before_destroy = true
}
}
