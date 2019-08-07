output "public_ip" {
    value = "${var.instance_count >= 1 ? "${join(", ", aws_instance.example.*.public_ip)}" : 0}"
}