variable "instance_count" {
    type = number
}

variable "user_data_script" {
    type = string
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
}
