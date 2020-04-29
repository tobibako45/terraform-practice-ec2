provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

resource "aws_vpc" "myVPC" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "false"
  tags = {
    Name = "myVPC"
  }
}

resource "aws_internet_gateway" "myGW" {
  vpc_id = aws_vpc.myVPC.id
}

resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.myVPC.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-northeast-1a"
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.myVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myGW.id
  }
}

resource "aws_route_table_association" "puclic-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_security_group" "mySG" {
  name        = "my-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.myVPC.id
  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_security_group" "web-server" {
  name        = "web-server"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.myVPC.id
  ingress {
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

resource "aws_instance" "my-test" {
  ami           = var.images.ap-northeast-1
  instance_type = "t2.micro"
  key_name      = "terraform-test"
  vpc_security_group_ids = [
    aws_security_group.mySG.id,
    aws_security_group.web-server.id
  ]
  subnet_id                   = aws_subnet.public-a.id
  associate_public_ip_address = "true"
  tags = {
    Name = "my-test"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = aws_instance.my-test.public_ip
      user = "ec2-user"
      # key_file = var.ssh_key_file
      private_key = file(var.ssh_key_file)
      script_path = "./script.sh"
    }
    # inline = [
    #   "sudo yum -y install nginx",
    #   "sudo service nginx start",
    #   "sudo chkconfig nginx on" # 自動起動
    # ]
    # inline = [
    #   "chmod +x ../tmp/script.sh",
    #   "../tmp/script.sh args",
    # ]
    script = "${path.module}/script.sh"
  }
}

output "public_ip_of_my-test" {
  value = aws_instance.my-test.public_ip
}
