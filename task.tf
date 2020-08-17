resource "aws_instance" "inet" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  key_name      = "${aws_key_pair.ec2key.key_name}"
  availability_zone = "us-east-1a"
  vpc_security_group_ids = ["${aws_security_group.allow_web.id}"]
  tags = {
  Name = "Web"
    }
}

resource "aws_key_pair" "ec2key" {
  key_name   = "task-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "Allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "ID" {
  value       = "${aws_instance.inet.id}"
}

output "KEY" {
  value       = "${aws_instance.inet.key_name}"
}

output "SEC GR" {
  value       = "${aws_security_group.allow_web.name}"
}