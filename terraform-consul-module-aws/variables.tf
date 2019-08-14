variable "instance_type" {
  description = "Specify the instance type."
}

variable "subnet_id" {}

variable "security_group_id" {
  type        = "list"
  description = "Security group that you want to use."
}

variable "ami_server" {
  type        = "map"
  description = "AMI IDs based on if node is a client or a server"

  default = {
    "1.3.0" = "ami-04fab3550d820396a"
    "1.4.3" = "ami-0085f11818f401bdf"
    "1.4.4" = "ami-0d9c2893a43ede4d8"
    "1.5.0" = "ami-07d163e08bb827aa2"
  }
}

variable "ami_client" {
  type        = "map"
  description = "AMI IDs based on if node is a client or a server"

  default = {
    "1.3.0" = "ami-0a28b47f37b9e2e19"
    "1.4.3" = "ami-06c350abb0d40236f"
    "1.4.4" = "ami-0b1d5f3289da64022"
    "1.5.0" = "ami-08841e3ee41f558b6"
  }
}

variable "domain" {
  default     = "consul"
  description = "Domain of the Consul cluster"
}

variable "dcname" {
  description = "Datacenter name of the Consul cluster"
}

variable "region" {
  description = "Specify the prefered AWS region"
}

variable "IP" {
  type        = "map"
  description = "IP segment based on if node is a server or a client."
}

variable "server_count" {
  description = "Count of Consul servers in DC1."
  default     = "3"
}

variable "nginx_client_count" {
  description = "Count of nginx consul clients in DC1."
  default     = "1"
}

variable "join_wan" {
  description = "Variable used to properly assign tags for auto join."
}

variable "verr" {}
