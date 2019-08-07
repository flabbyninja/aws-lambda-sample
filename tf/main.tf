provider "aws" {
    region = "eu-west-1"
}

data "aws_caller_identity" "current" {}

module "provision-ec2-apache"{
  source = "./modules/ec2-apache"
  instance_count = "${var.instance_count}"
  user_data_script = "${var.user_data_script}"
  server_port = "${var.server_port}"
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
resource "aws_iam_role_policy_attachment" "attach_lambda_execute" {
  role = "${aws_iam_role.lambda_execution.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# define a role with a trust relationship to API Gateway
resource "aws_iam_role" "api_gateway_cloudwatch" {
  name = "lambda_sample_api_gateway_cloudwatch"
  description = "Give API Gateway access to Cloudwatch to write logs"
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

# Create policy that allows the correct role to be assumed
resource "aws_iam_policy" "assume_user_policy" {
  name        = "lambda_sample_api_gateway_assume_user_policy"
  description = "Policy to allow user role to be assumed via STS for lambda-sample"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/user/${var.assume_user_role}"
    }
  ]
}
POLICY
}

# Bind ability to assume to correct user to the role
resource "aws_iam_role_policy_attachment" "attach_api_gateway_user" {
  role = "${aws_iam_role.api_gateway_cloudwatch.name}"
  policy_arn = "${aws_iam_policy.assume_user_policy.arn}"
}

# Bind API Gateway AWS Managed Cloudwatch push policy to the role
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_push" {
  role = "${aws_iam_role.api_gateway_cloudwatch.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}