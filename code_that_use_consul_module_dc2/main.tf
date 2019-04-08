module "dc2" {
  source = "../terraform-consul-module-aws"

  instance_type     = "${var.instance_type}"
  security_group_id = "${var.security_group_id}"
  region            = "${var.region}"
  dcname            = "${var.dcname["dc2"]}"
  IP                = "${var.IP_dc2}"
  subnet_id         = "${var.subnet_id["dc2"]}"
  join_wan          = "${var.join_wan}"
}

output "server_ips_dc2" {
  value = "${module.dc2.server_ips}"
}

output "nginx_client_count" {
  value = "${module.dc2.nginx_client_count}"
}

output "client_ami" {
  value = "${module.dc2.client_ami}"
}

output "instance_type" {
  value = "${module.dc2.instance_type}"
}

output "security_group_id" {
  value = "${module.dc2.security_group_id}"
}

output "dcname" {
  value = "${module.dc2.dcname}"
}

output "IP_client" {
  value = "${module.dc2.IP_client}"
}

output "subnet_id" {
  value = "${module.dc2.subnet_id}"
}

output "data_rendered" {
  value = "${module.dc2.data_rendered}"
}

output "instance_profile" {
  value = "${module.dc2.iam_instance_profile}"
}

output "key_pair" {
  value = "${module.dc2.key_pair}"
}
