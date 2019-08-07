variable "instance_count" {
    description = "Number of EC2 instances to create"
    type = number
}

variable "user_data_script" {
    description = "Location of EC2 user data script to install apache"
    type = string
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
}
