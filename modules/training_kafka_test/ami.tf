data "aws_ami" "training_kafka_test" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["data-eng-kafka-training-*"]
  }
}
