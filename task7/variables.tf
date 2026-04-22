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

variable "ext_ip" {
  type        = bool
  default     = true
  description = "use external ip"
}

variable "vm_user" {
  type    = string
  default = "osho"
}

variable "task7" {
  type    = map(list(string))
  default = {
    "network_id"   = ["enp7i560tb28nageq0cc"]
    "subnet_ids"   = [
      "e9b0le401619ngf4h68n",
      "e2lbar6u8b2ftd7f5hia",
      "b0ca48coorjjq93u36pl",
      "fl8ner8rjsio6rcpcf0h",
    ]
    "subnet_zones" = [
      "ru-central1-a",
      "ru-central1-b",
      "ru-central1-c",
      "ru-central1-d",
    ]
  }
}