#  Create a Security Group with Firewall Rules
resource "aws_security_group" "sec_group" {
  description = "Allow limited Inbound external traffic"
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "tf_ec2_private_sg"

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }

  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_instance" "public_instance" {
  ami = "ami-0c1a7f89451184c8b"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sec_group.id}"]
  subnet_id = "${aws_subnet.public_subnet.id}"
  key_name = var.key_name
  count = 1
  associate_public_ip_address = true
}

resource "aws_instance" "private_instance" {
  ami = "ami-0c1a7f89451184c8b"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sec_group.id}"]
  subnet_id = "${aws_subnet.private_subnet.id}"
  key_name = var.key_name
  count = 1
  associate_public_ip_address = false
}