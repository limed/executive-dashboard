variable "account" {
  default = "nubis-market"
}

variable "region" {
  default = "us-west-2"
}

variable "environment" {
  default = "stage"
}

variable "service_name" {
  default = "executive-dashboard"
}

variable "instance_type" {
  default = "t2.small"
}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "ami" {}
