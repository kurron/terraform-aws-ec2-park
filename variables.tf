variable "region" {
    type = "string"
    description = "The AWS region to deploy into (e.g. us-east-1)"
}

variable "name" {
    type = "string"
    description = "What to name the resources being created"
}

variable "project" {
    type = "string"
    description = "Name of the project these resources are being created for"
}

variable "purpose" {
    type = "string"
    description = "The role the resources will play"
}

variable "creator" {
    type = "string"
    description = "Person creating these resources"
}

variable "environment" {
    type = "string"
    description = "Context these resources will be used in, e.g. production"
}

variable "freetext" {
    type = "string"
    description = "Information that does not fit in the other tags"
}

variable "ami_regexp" {
    type = "string"
    description = "Regular expression to use when looking up an AMI in the specified region"
}

variable "ebs_optimized" {
    type = "string"
    description = "Boolean indicating if the instance should enable EBS optimization or not"
}

variable "instance_type" {
    type = "string"
    description = "They instance type to build the instances from"
}

variable "ssh_key_name" {
    type = "string"
    description = "Name of the SSH key to install onto the instances"
}

variable "security_group_ids" {
    type = "list"
    description = "List of security groups to apply to the instances"
}

variable "subnet_ids" {
    type = "list"
    description = "List of subnets to create the instances in"
}

variable "instance_profile" {
    type = "string"
    description = "ID of the IAM profile to associate with the instances"
}

variable "scheduled" {
    type = "string"
    description = "If set to Yes, the instances will be parked on a schedule"
}

variable "associate_public_ip_address" {
    type = "string"
    description = "If set to true, the instances will have public ip addresses associated to them"
}
