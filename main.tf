provider "aws" {
  region = "${data.template_file.aws_region.rendered}"
  profile = "${var.aws_profile}"
}

data "template_file" "aws_region" {
  template = "$${region}"

  vars {
    #Change the number 13 to number specific to your region from variables.tf file.
    region = "${lookup(var.aws_region_list,"13")}"
  }
}

#================ Print AWS region selected ================
output "aws_region" {
  value = "${data.template_file.aws_region.rendered}"
}

#================ Fetching latest AMI ================
data "aws_ami" "aws_latest_ami" {
  most_recent = "true"

  filter {
    name   = "name"
    values = ["OpenVPN Access Server*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  owners = ["573553919781"]
}

#================ Print AMI ID ================
output "ami_id" {
  value = "${data.aws_ami.aws_latest_ami.image_id}"
}
output "ami_name" {
  value = "${data.aws_ami.aws_latest_ami.name}"
}

#================ VPC ================
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"

  tags {
    Name = "vpn-vpc"
  }
}

#================ IGW ================
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "vpn-vpc-igw"
  }
}

#================ Public Subnet ================
resource "aws_subnet" "pub_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${data.template_file.aws_region.rendered}a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags {
    Name = "vpn-pub-subnet"
  }
}

#================ Route Table ================
resource "aws_route_table" "pub_rtb" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "pub-rtb"
  }
}

#================ Route Table Association ================
resource "aws_route_table_association" "pub_rtb_assoc" {
  subnet_id = "${aws_subnet.pub_subnet.id}"
  route_table_id = "${aws_route_table.pub_rtb.id}"
}

#================ Security Groups ================
resource "aws_security_group" "vpn_sg" {
  name = "vpn-sg"
  description = "OpenVPN Security Group"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #Restrict to you own IP
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 943
    to_port = 943
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 1194
    to_port = 1194
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "vpn-sg"
  }
}

#================ Key Pair ================
resource "aws_key_pair" "vpn_key" {
  key_name = "vpn-key"
  public_key = "${file("public-key")}"
}

#================ VPN Instance ================
resource "aws_instance" "instance" {
  ami = "${data.aws_ami.aws_latest_ami.id}"
  availability_zone = "${data.template_file.aws_region.rendered}a"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.vpn_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.vpn_sg.id}"]
  subnet_id = "${aws_subnet.pub_subnet.id}"
  user_data = "${file("user-data.txt")}"

  tags {
    Name = "vpn-instance"
  }
}

#================ Elastic IP (Optional) ================
resource "aws_eip" "eip" {
  instance = "${aws_instance.instance.id}"
  vpc = "true"
}
