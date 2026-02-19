variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "aleksandr-key-pro"
}

variable "server_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "Aleksandr-Web-Server-Variable"
}