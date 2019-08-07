variable "assume_user_role" {
    description = "Name of the user to assume for Lambda execution"
    type = string
}

variable "instance_count" {
    description = "Number of EC2 instances to create"
    type = number
}

variable "user_data_script" {
    description = "Location of EC2 user data script"
    type = string
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
}
