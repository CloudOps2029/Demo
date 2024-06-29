# Demo
Demo Project

# AWS Infrastructure with Terraform

## Overview

This Terraform configuration sets up the following resources in AWS:

- S3 bucket and DynamoDB table for Terraform backend
- VPC with one public and one private subnet in the Canada region
- Internet Gateway, NAT Gateway, and route tables
- Security groups for ALB and EC2 instances
- Autoscaling group with EC2 instances that serve a simple HTML page displaying the hostname
- Application Load Balancer (ALB) in front of the Autoscaling group

## Architecture

The architecture includes:
- A VPC in the Canada region
- One public and one private subnet
- An Internet Gateway and a NAT Gateway
- Route tables for the public and private subnets
- An Application Load Balancer (ALB)
- An Autoscaling Group (ASG) with EC2 instances
- Security Groups for the ALB and EC2 instances


