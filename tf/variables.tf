variable "assume_user_role" {
    type = "string"
}

variable "create_ec2" {
    type = "string"
}

variable "instance_count" {
    type = number
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
}
