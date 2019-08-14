# Below are resources needed for enabling the consul auto-join function. 
# EC2 instaces need to have iam_instance_profile with the below policy and 
# set of rules so each EC2 can read the metadata in order to find the private_ips based on a specific tag key/value.
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "consul" {
  name_prefix        = "consul_role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "consul" {
  statement {
    sid       = "AllowSelfAssembly"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "ec2:DescribeVpcs",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
    ]
  }
}

resource "aws_iam_role_policy" "consul" {
  name_prefix = "consul_role"
  role        = "${aws_iam_role.consul.id}"
  policy      = "${data.aws_iam_policy_document.consul.json}"
}

resource "aws_iam_instance_profile" "consul" {
  name_prefix = "consul_role"
  role        = "${aws_iam_role.consul.name}"
}

# Resource needed in order to be able to SSH and provision the EC2 instances
resource "aws_key_pair" "key" {
  key_name   = "key_${var.dcname}"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

# Data source that is needed in order to dinamicly publish values of variables into the script that is creating Consul configuration files and starting it.

data "template_file" "var" {
  template = "${file("${path.module}/scripts/start_consul.tpl")}"

  vars = {
    DOMAIN       = "${var.domain}"
    DCNAME       = "${var.dcname}"
    LOG_LEVEL    = "debug"
    SERVER_COUNT = "${var.server_count}"
    var2         = "$(hostname)"
    IP           = "$(hostname -I)"
    JOIN_WAN     = "${var.join_wan}"
  }
}

# Below are the 3 Consul servers and 1 consul client.
resource "aws_instance" "consul_servers" {
  ami                         = "${var.ami_server["${var.verr}"]}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${aws_key_pair.key.id}"
  vpc_security_group_ids      = "${var.security_group_id}"
  iam_instance_profile        = "${aws_iam_instance_profile.consul.id}"
  private_ip                  = "${var.IP["server"]}${count.index + 1}"
  associate_public_ip_address = true
  count                       = "${var.server_count}"

  tags = {
    Name     = "consul-server${count.index + 1}"
    consul   = "${var.dcname}"
    join_wan = "${var.join_wan}"
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
    content     = "${data.template_file.var.rendered}"
    destination = "/var/tmp/scripts/start_consul.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash /var/tmp/scripts/start_consul.sh",
      "sudo bash /var/tmp/scripts/keyvalue.sh",
    ]
  }
}

# Outputs the instances public ips.

output "server_ips" {
  value = "${aws_instance.consul_servers.*.public_ip}"
}

output "nginx_client_count" {
  value = "${var.nginx_client_count}"
}

output "client_ami" {
  value = "${var.ami_client["${var.verr}"]}"
}

output "instance_type" {
  value = "${aws_instance.consul_servers.*.instance_type[0]}"
}

output "security_group_id" {
  value = "${aws_instance.consul_servers.*.vpc_security_group_ids[0]}"
}

output "dcname" {
  value = "${var.dcname}"
}

output "IP_client" {
  value = "${var.IP["client"]}"
}

output "subnet_id" {
  value = "${aws_instance.consul_servers.*.subnet_id[0]}"
}

output "data_rendered" {
  value      = "${data.template_file.var.rendered}"
  depends_on = ["data.template_file.var"]
}

output "iam_instance_profile" {
  value = "${aws_iam_instance_profile.consul.id}"
}

output "key_pair" {
  value = "${aws_key_pair.key.id}"
}
