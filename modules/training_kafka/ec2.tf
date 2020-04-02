data "local_file" "kafka_mount_setup" {
  filename = "${path.module}/scripts/kafka_mount_setup.sh"
}

data "template_cloudinit_config" "kafka" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.local_file.kafka_mount_setup.content}"
  }
}

resource "aws_instance" "kafka" {
  ami                    = "${data.aws_ami.training_kafka.image_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.kafka.id}"]
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.ec2_key_pair}"
  iam_instance_profile   = "${aws_iam_instance_profile.kafka.name}"
  root_block_device = [{
    volume_type           = "${var.root_volume_type}"
    volume_size           = "${var.root_volume_size}"
  }]
  user_data = "${data.template_cloudinit_config.kafka.rendered}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "kafka-${var.deployment_identifier}"
    )
  )}"
}
