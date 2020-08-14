resource "aws_instance" "inet" {
  ami           = "ami-067f5c3d5a99edc80"
  instance_type = "t2.large"
  associate_public_ip_address = "true"
  # key_name      = "${aws_key_pair.bastion.bastion}"
  user_data     = "${file("ec2data.sh")}"
  availability_zone = "us-west-2a"
  vpc_security_group_ids = ["${aws_security_group.allow_web.id}"]
  tags = {
  Name = "Web"
    }
}
# resource "aws_key_pair" "bastion" {
#   key_name   = "bastion-key"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFsBq5CSpcKqFeUXMsUHRwH0YcOB4mrRnlY85eOrW71hzuDSZ3NsnkH3Ff7MJrt0I7UXeK/gVIz3bEScz8EWVdfxHGVYVsV8i4mao7vJ4GRa2XRTEJrP7y65jMQAAtwSHis+4Ax/preL0mQ4x9jwQAtcSh8Fy6nLCsTwz1mLYapWmgDafdmNgJtKjShnarTS6++48Qhc9xQfsmbo9o+KDhJbyfH/2WKF/D6jdVCBLz0f/P4/hAf35MhHhSNH94eYUiyIsWTf+u1YOGtolPRWVNs7dQTzlGGWndx9v4YSDC9gRvlg3K2cwu8wVnr+Ta+9xzZD4mMDC9XzAbypUDTtBL ec2-user@ip-172-31-32-157.eu-west-1.compute.internal"
# }

# resource "aws_key_pair" "ec2key" {
#   key_name   = "task-key"
#   public_key = "${file("~/.ssh/id_rsa.pub")}"
# }
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
  type    = "CNAME"
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
