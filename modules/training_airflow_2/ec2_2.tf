data "local_file" "airflow_install" {
  filename = "${path.module}/scripts/install_airflow.sh"
}

data "template_cloudinit_config" "airflow" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.local_file.airflow_install.content}"
  }
}

resource "aws_instance" "airflow_2" {
  # FIXME: Use a specialised airflow AMI
  ami                    = "${data.aws_ami.amazon_linux_2.image_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.airflow_2.id}"]
  subnet_id              = "${var.subnet_ids[0]}"
  key_name               = "${var.ec2_key_pair}"
  iam_instance_profile   = "${aws_iam_instance_profile.airflow_2.name}"
  user_data = "${data.template_cloudinit_config.airflow.rendered}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "airflow_2-${var.deployment_identifier}"
    )
  )}"

  # TODO: Remove this once we have dedicated airflow AMI
  lifecycle {
    ignore_changes = ["ami"]
  }
}

