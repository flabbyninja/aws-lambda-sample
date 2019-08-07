resource "aws_instance" "example" {
    count         = "${var.instance_count >= 1 ? var.instance_count : 0}"
    ami           = "ami-0bbc25e23a7640b9b"
    instance_type = "t2.micro"
    key_name      = "dev-key"
    vpc_security_group_ids = [aws_security_group.instance.id]
    user_data     = "${file(var.user_data_script)}"

    tags = {
        Name      = "terraform-example-${count.index}"
    }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance" 
  
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}