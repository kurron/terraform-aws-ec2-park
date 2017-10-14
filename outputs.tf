output "instance_ids" {
    value = ["${aws_instance.instance.*.id}"]
    description = "IDs of the created instances"
}
