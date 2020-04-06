resource "aws_ebs_volume" "kafka-ebs-volume" {
  availability_zone = "ap-southeast-1a"
  size = 100
}
resource "aws_volume_attachment" "test_ebs_att" {
  device_name = "/dev/sdf"
  volume_id   = "${aws_ebs_volume.kafka-ebs-volume.id}"
  instance_id = "${aws_instance.kafka.id}"
  skip_destroy = true
}
