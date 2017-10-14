variable "region" {
    type = "string"
    description = "The AWS region to deploy into (e.g. us-east-1)"
}

variable "project" {
    type = "string"
    description = "Name of the project these resources are being created for"
}

variable "creator" {
    type = "string"
    description = "Person creating the resources"
}

variable "environment" {
    type = "string"
    description = "Context the resources will be used in, e.g. production"
}

variable "freetext" {
    type = "string"
    description = "Information that does not fit in the other tags"
}

variable "role_arn" {
    type = "string"
    description = "ARN of the role that has rights to start and stop EC2 instances"
}

variable "start_cron_expression" {
    type = "string"
    description = "Cron expression describing when the instances should be started"
}

variable "stop_cron_expression" {
    type = "string"
    description = "Cron expression describing when the instances should be stopped"
}
