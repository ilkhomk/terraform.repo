resource "aws_instance" "inet" {
  ami           = "ami-0873b46c45c11058d"
  instance_type = "t2.large"
  associate_public_ip_address = "true"
  key_name      = "${aws_key_pair.ec2key.key_name}"
  user_data     = "${file("ec2data.sh")}"
  availability_zone = "us-west-2a"
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
resource "aws_ebs_volume" "disk" {
    availability_zone = "us-west-2a"
    size = 100
}

resource "aws_volume_attachment" "ebs_disk" {
    device_name = "/dev/sdh"
    volume_id = "${aws_ebs_volume.disk.id}"
    instance_id = "${aws_instance.inet.id}"
}
resource "aws_route53_record" "www" {
  zone_id = "Z1023849MNLCJKQ28NTZ"
  name    = "www.ilkhom-k.com"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.inet.public_ip}"]
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

output "ROUTE53" {
  value       = "${aws_route53_record.www.name}"
}
