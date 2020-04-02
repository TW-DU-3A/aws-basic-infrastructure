resource "aws_ebs_volume" "airflow_2_ebs_volume" {
  availability_zone = "ap-southeast-1a"
  size              = 6
}
resource "aws_volume_attachment" "airflow_2_ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.airflow_2_ebs_volume.id}"
  instance_id = "${aws_instance.airflow_2.id}"
  skip_destroy = true
}