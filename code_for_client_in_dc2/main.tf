provider "aws" {
  region = "us-east-1"
}
data "terraform_remote_state" "state" {
  backend = "local"

  config = {
    path = "../code_that_use_consul_module_dc2/terraform.tfstate"
  }
}

resource "aws_instance" "nginx_clients" {
  ami                         = "${data.terraform_remote_state.state.outputs.client_ami}"
  instance_type               = "${data.terraform_remote_state.state.outputs.instance_type}"
  subnet_id                   = "${data.terraform_remote_state.state.outputs.subnet_id}"
  key_name                    = "${data.terraform_remote_state.state.outputs.key_pair}"
  vpc_security_group_ids      = data.terraform_remote_state.state.outputs.security_group_id
  iam_instance_profile        = "${data.terraform_remote_state.state.outputs.instance_profile}"
  private_ip                  = "${data.terraform_remote_state.state.outputs.IP_client}${count.index + 1}"
  associate_public_ip_address = true
  count                       = "${data.terraform_remote_state.state.outputs.nginx_client_count}"

  tags = {
    Name   = "consul-client${count.index + 1}"
    consul = "${data.terraform_remote_state.state.outputs.dcname}"
  }

  connection {
    user        = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "${path.module}/scripts"
    destination = "/var/tmp"
  }

  provisioner "file" {
    content     = "${data.terraform_remote_state.state.outputs.data_rendered}"
    destination = "/var/tmp/scripts/start_consul.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash /var/tmp/scripts/start_consul.sh",
      "sudo bash /var/tmp/scripts/consul-template.sh",
      "sudo bash /var/tmp/scripts/conf-dnsmasq.sh",
      "sudo bash /var/tmp/scripts/check_nginx.sh",
      "sleep 20",
      "consul reload",
    ]
  }
}

output "client_ips" {
  value = "${aws_instance.nginx_clients.*.public_ip}"
}
