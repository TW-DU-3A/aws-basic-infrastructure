data "local_file" "kafka_test_mount_setup" {
  filename = "${path.module}/scripts/kafka_mount_setup.sh"
}

data "template_cloudinit_config" "kafka_test" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.local_file.kafka_test_mount_setup.content}"
  }
}

resource "aws_instance" "kafka_test" {
  ami                    = "${data.aws_ami.training_kafka_test.image_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.kafka_test.id}"]
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.ec2_key_pair}"
  iam_instance_profile   = "${aws_iam_instance_profile.kafka_test.name}"
  user_data = "${data.template_cloudinit_config.kafka_test.rendered}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "kafka_test-${var.deployment_identifier}"
    )
  )}"
}
