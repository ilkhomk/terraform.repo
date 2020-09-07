resource "aws_subnet" "public1" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.public_cidr1}"
  availability_zone = "${var.region}a"
  tags              = "${var.tags}"
}

resource "aws_subnet" "public2" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.public_cidr2}"
  availability_zone = "${var.region}b"
  tags              = "${var.tags}"
}

resource "aws_subnet" "public3" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.public_cidr3}"
  availability_zone = "${var.region}c"
  tags              = "${var.tags}"
}
