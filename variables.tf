variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "enable_single_nat_gateway" {
  type = bool
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_key_name" {
  type = string
}

variable "device_name" {
  type = string
}

variable "vg_name" {
  type = string
}

variable "lv_name" {
  type = string
}

variable "data_path" {
  type = string
}
