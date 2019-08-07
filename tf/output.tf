output "public_ip" {
    value = "${module.provision-ec2-apache.public_ip}"
}