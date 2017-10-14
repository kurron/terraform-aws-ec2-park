terraform {
    required_version = ">= 0.10.6"
    backend "s3" {}
}

data "terraform_remote_state" "iam" {
    backend = "s3"
    config {
        bucket = "transparent-test-terraform-state"
        key    = "us-west-2/debug/security/iam/terraform.tfstate"
        region = "us-east-1"
    }
}

module "ec2_park" {
    source = "../"

    region                = "us-west-2"
    project               = "Debug"
    creator               = "kurron@jvmguy.com"
    environment           = "development"
    freetext              = "No notes at this time."
    role_arn              = "${data.terraform_remote_state.iam.ec2_park_role_arn}"
    start_cron_expression = "cron(0 7 ? * MON-FRI *)"
    stop_cron_expression  = "cron(0 0 ? * MON-FRI *)"

}
