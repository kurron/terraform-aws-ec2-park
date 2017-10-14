terraform {
    required_version = ">= 0.10.6"
    backend "s3" {}
}

data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "transparent-test-terraform-state"
        key    = "us-west-2/debug/networking/vpc/terraform.tfstate"
        region = "us-east-1"
    }
}

data "terraform_remote_state" "security-groups" {
    backend = "s3"
    config {
        bucket = "transparent-test-terraform-state"
        key    = "us-west-2/debug/networking/security-groups/terraform.tfstate"
        region = "us-east-1"
    }
}

data "terraform_remote_state" "bastion" {
    backend = "s3"
    config {
        bucket = "transparent-test-terraform-state"
        key    = "us-west-2/debug/compute/bastion/terraform.tfstate"
        region = "us-east-1"
    }
}

data "terraform_remote_state" "iam" {
    backend = "s3"
    config {
        bucket = "transparent-test-terraform-state"
        key    = "us-west-2/debug/security/iam/terraform.tfstate"
        region = "us-east-1"
    }
}

module "ec2" {
    source = "../"

    region                      = "us-west-2"
    name                        = "Ultron"
    project                     = "Debug"
    purpose                     = "Runs Docker containers"
    creator                     = "kurron@jvmguy.com"
    environment                 = "development"
    freetext                    = "No notes at this time."
    ami_regexp                  = "^amzn-ami-.*-amazon-ecs-optimized$"
    ebs_optimized               = "false"
    associate_public_ip_address = "false"
    instance_type               = "t2.nano"
    ssh_key_name                = "${data.terraform_remote_state.bastion.ssh_key_name}"
    security_group_ids          = ["${data.terraform_remote_state.security-groups.ec2_id}"]
    subnet_ids                  = "${data.terraform_remote_state.vpc.private_subnet_ids}"
    instance_profile            = "${data.terraform_remote_state.iam.cross_account_ecr_pull_profile_id}"
    scheduled                   = "Yes"
}

output "instance_ids" {
    value = "${module.ec2.instance_ids}"
}
