resource "aws_instance" "web" {
  #count = 10
  ami           = "ami-02354e95b39ca8dec"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  key_name      = "${aws_key_pair.class.key_name}"
  #user_data     = "${file("userdata.sh")}"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  availability_zone = "us-east-1a"


    tags = {
        Name = "HelloWorld"
        Env = "Development"
        Client = "panera_bread"
        Team = "DevOps"
        Created_by = "Farrukh"
    }

}
