terraform {
    required_version = ">= 0.10.6"
    backend "s3" {}
}

provider "aws" {
    region     = "${var.region}"
}

data "template_file" "start_lambda" {
    template = "${file("${path.module}/files/start-lambda.py.template")}"
    vars {
        project = "${var.project}"
        environment = "${var.environment}"
    }
}

data "archive_file" "start_lambda" {
    type        = "zip"
    output_path = "${path.module}/archives/start-lambda.zip"

    source {
        content  = "${data.template_file.start_lambda.rendered}"
        filename = "start-lambda.py"
    }
}

resource "aws_lambda_function" "start_lambda" {
    filename = "${path.module}/archives/start-lambda.zip"
    function_name = "ec2-scheduled-start"
    handler = "start-lambda.lambda_handler"
    role = "${var.role_arn}"
    description = "Turns on EC2 instances that match the specified tag values"
    runtime = "python3.6"
    source_code_hash = "${data.archive_file.start_lambda.output_base64sha256}"
    tags {
        Name = "EC2 Scheduled Start"
        Project = "${var.project}"
        Purpose = "Starts EC2 instances that match the specified tags"
        Creator = "${var.creator}"
        Environment = "${var.environment}"
        Freetext = "${var.freetext}"
    }
}

data "template_file" "stop_lambda" {
    template = "${file("${path.module}/files/stop-lambda.py.template")}"
    vars {
        project = "${var.project}"
        environment = "${var.environment}"
    }
}

data "archive_file" "stop_lambda" {
    type        = "zip"
    output_path = "${path.module}/archives/stop-lambda.zip"

    source {
        content  = "${data.template_file.stop_lambda.rendered}"
        filename = "stop-lambda.py"
    }
}

resource "aws_lambda_function" "stop_lambda" {
    filename = "${path.module}/archives/stop-lambda.zip"
    function_name = "ec2-scheduled-stop"
    handler = "stop-lambda.lambda_handler"
    role = "${var.role_arn}"
    description = "Turns off EC2 instances that match the specified tag values"
    runtime = "python3.6"
    source_code_hash = "${data.archive_file.stop_lambda.output_base64sha256}"
    tags {
        Name = "EC2 Scheduled Stop"
        Project = "${var.project}"
        Purpose = "Stops EC2 instances that match the specified tags"
        Creator = "${var.creator}"
        Environment = "${var.environment}"
        Freetext = "${var.freetext}"
    }
}
