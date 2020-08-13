resource "aws_instance" "inet" {
  ami           = "ami-02354e95b39ca8dec"
  instance_type = "t2.large"
  associate_public_ip_address = "true"
  key_name      = "${aws_key_pair.ec2key.task-key}"
  user_data     = "${file("ec2data.sh")}"
  availability_zone = "us-west-2a"

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
    availability_zone = "us-east-1a"
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
  ttl     = "30"
  records = ["${aws_instance.inet.public_ip}"]
}