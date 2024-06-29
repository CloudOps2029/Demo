variable "launch_config_name" {
  description = "The name of the launch configuration"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum size of the ASG"
  type        = number
}

variable "max_size" {
  description = "Maximum size of the ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Desired capacity of the ASG"
  type        = number
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ASG"
  type        = list(string)
}

variable "asg_name" {
  description = "Name of the ASG"
  type        = string
}

variable "tags" {
  description = "Tags for the ASG"
  type        = map(string)
  default     = {}
}

variable "target_group_arn" {
  description = "ARN of the target group for the ASG"
  type        = string
}

variable "scale_up_adjustment" {
  description = "Scaling adjustment for scale up policy"
  type        = number
}

variable "scale_down_adjustment" {
  description = "Scaling adjustment for scale down policy"
  type        = number
}

variable "cooldown" {
  description = "Cooldown period in seconds"
  type        = number
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}