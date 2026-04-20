variable "cloud_id" {
  type        = string
  default = "b1gc3k00qi2fi08ed282"
}

variable "folder_id" {
  type        = string
  default = "b1gbhs59559ntu7hvlcn"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}
