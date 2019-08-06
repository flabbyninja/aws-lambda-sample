provider "aws" {
    region = "eu-west-1"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}

resource "aws_instance" "example" {
    ami           = "ami-0bbc25e23a7640b9b"
    instance_type = "t2.micro"
    key_name      = "dev-key"
    vpc_security_group_ids = [aws_security_group.instance.id]
    user_data     = "${file("install_httpd.sh")}"

    tags = {
        Name      = "terraform-example"
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

output "public_ip" {
    value = aws_instance.example.public_ip
    description = "Public IP of the web server"
}

# define a role with a trust relationship to Lambda
resource "aws_iam_role" "lambda_execution" {
  name = "lambda_sample_lambda_execution"
  description = "Allow base execution of lambdas"
  assume_role_policy = <<TRUST_RELATIONSHIP
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
TRUST_RELATIONSHIP

  tags = {
    tag-key = "terraform"
  }
}

# Bind basic lambda execution policy to the role
resource "aws_iam_role_policy_attachment" "test-attach" {
  role = "${aws_iam_role.lambda_execution.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# define a role with a trust relationship to API Gateway
resource "aws_iam_role" "api_gateway_cloudwatch" {
  name = "lambda_sample_api_gateway_cloudwatch"
  description = "Allow API Gateway to have access to Cloudwatch to write logs"
  assume_role_policy = <<TRUST_RELATIONSHIP
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
TRUST_RELATIONSHIP

  tags = {
    tag-key = "terraform"
  }
}
