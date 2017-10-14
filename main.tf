terraform {
    required_version = ">= 0.10.6"
    backend "s3" {}
}

provider "aws" {
    region     = "${var.region}"
}

data "aws_ami" "lookup" {
    most_recent = true
    name_regex  = "${var.ami_regexp}"
    owners      = ["amazon"]
    filter {
       name   = "architecture"
       values = ["x86_64"]
    }
    filter {
       name   = "image-type"
       values = ["machine"]
    }
    filter {
       name   = "state"
       values = ["available"]
    }
    filter {
       name   = "virtualization-type"
       values = ["hvm"]
    }
    filter {
       name   = "hypervisor"
       values = ["xen"]
    }
    filter {
       name   = "root-device-type"
       values = ["ebs"]
    }
}

resource "aws_instance" "instance" {
    count = "${length( var.subnet_ids )}"

    ami                         = "${data.aws_ami.lookup.id}"
    ebs_optimized               = "${var.ebs_optimized}"
    instance_type               = "${var.instance_type}"
    key_name                    = "${var.ssh_key_name}"
    monitoring                  = true
    associate_public_ip_address = "${var.associate_public_ip_address}"
    vpc_security_group_ids      = ["${var.security_group_ids}"]
    subnet_id                   = "${element( var.subnet_ids, count.index )}"
    iam_instance_profile        = "${var.instance_profile}"

    tags {
        Name        = "${format( "${var.name} %02d", count.index+1 )}"
        Project     = "${var.project}"
        Purpose     = "${var.purpose}"
        Creator     = "${var.creator}"
        Environment = "${var.environment}"
        Freetext    = "${var.freetext}"
        Scheduled   = "${var.scheduled}"
    }
    volume_tags {
        Name        = "${format( "${var.name} %02d", count.index+1 )}"
        Project     = "${var.project}"
        Purpose     = "${var.purpose}"
        Creator     = "${var.creator}"
        Environment = "${var.environment}"
        Freetext    = "${var.freetext}"
    }
}
