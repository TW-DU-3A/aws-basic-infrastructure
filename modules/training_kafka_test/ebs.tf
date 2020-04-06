resource "aws_ebs_volume" "kafka_test-ebs-volume" {
  availability_zone = "ap-southeast-1a"
  size = 11
}
resource "aws_volume_attachment" "test_ebs_att" {
  device_name = "/dev/sdf"
  volume_id   = "${aws_ebs_volume.kafka_test-ebs-volume.id}"
  instance_id = "${aws_instance.kafka_test.id}"
  skip_destroy = true
}
