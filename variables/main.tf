
terraform {
  backend "s3" {
    bucket         = "tf-be-bucket"
    key            = "terraforms.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "tf-lock-table"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    } 
  }
}

provider "aws" {
  region     = "ca-central-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}



# VPC Configuration
module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = "10.1.0.0/16"
  vpc_name             = "my-vpc"
  private_subnet_cidr  = "10.1.1.0/24"
  public_subnet_cidr   = "10.1.2.0/24"
  public_subnet_name   = "pub-subnet"
  private_subnet_name  = "priv-subnet"
  igw_name             = "my-igw"
  nat_gateway_name     = "nat-gateway"
  public_route_table_name  = "public-rt"
  private_route_table_name = "private-rt"
}

# EC2 IAM Role Configuration
module "ec2_role" {
  source       = "./modules/ec2"
  iam_role_name = "ec2-minimal-role"
}

# ALB Configuration
module "alb" {
  source              = "./modules/alb"
  alb_name            = "my-alb"
  security_group_ids  = [aws_security_group.alb.id]
  subnet_ids          = [module.vpc.public_subnet_id,module.vpc.public_subnet_id2]
  target_group_name   = "my-target-group"
  vpc_id              = module.vpc.vpc_id
}

# ASG Configuration
module "asg" {
  source              = "./modules/asg"
  launch_config_name  = "my-launch-config"
  ami_id              = "ami-0c55b159cbfafe1f0"
  instance_type       = "m4.xlarge"
  security_group_ids  = [aws_security_group.alb.id]
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1
  subnet_ids          = [module.vpc.public_subnet_id]
  asg_name            = "my-asg"
  vpc_id              = module.vpc.vpc_id
  target_group_arn    = module.alb.target_group_arn
  scale_up_adjustment = 1
  scale_down_adjustment = -1
  cooldown            = 300
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# Security Group for EC2 Instances
resource "aws_security_group" "ec2" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

# Backend Configuration
# module "backend" {
#   source              = "./modules/backend"
#   bucket_name         = "tf-be-bucket"
#   dynamodb_table_name = "tf-lock-table"
# }
