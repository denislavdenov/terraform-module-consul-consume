module "dc1" {
  source = "git::ssh://git@github.com:denislavdenov/terraform-module-consul-consume.git//code_for_client_in_dc1"

  verr              = "${var.verr}"
  instance_type     = "${var.instance_type}"
  security_group_id = "${var.security_group_id}"
  region            = "${var.region}"
  dcname            = "${var.dcname["dc1"]}"
  IP                = "${var.IP_dc1}"
  subnet_id         = "${var.subnet_id["dc1"]}"
  join_wan          = "${var.join_wan}"
}

output "server_ips_dc1" {
  value = "${module.dc1.server_ips}"
}

output "nginx_client_count" {
  value = "${module.dc1.nginx_client_count}"
}

output "client_ami" {
  value = "${module.dc1.client_ami}"
}

output "instance_type" {
  value = "${module.dc1.instance_type}"
}

output "security_group_id" {
  value = "${module.dc1.security_group_id}"
}

output "dcname" {
  value = "${module.dc1.dcname}"
}

output "IP_client" {
  value = "${module.dc1.IP_client}"
}

output "subnet_id" {
  value = "${module.dc1.subnet_id}"
}

output "data_rendered" {
  value = "${module.dc1.data_rendered}"
}

output "instance_profile" {
  value = "${module.dc1.iam_instance_profile}"
}

output "key_pair" {
  value = "${module.dc1.key_pair}"
}
