##########################################
# 1️⃣ Get Default VPC
##########################################
data "aws_vpc" "default" {
  default = true
}

##########################################
# 2️⃣ Get All Subnets in Default VPC
##########################################
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

##########################################
# 3️⃣ Security Group
##########################################
resource "aws_security_group" "web_sg" {
  name        = "terraform-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = {
    Name = "terraform-sg"
  }
}

##########################################
# 4️⃣ EC2 Instance
##########################################
resource "aws_instance" "my_ec2" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"
  key_name      = "key"

  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Terraform-EC2"
  }
}
