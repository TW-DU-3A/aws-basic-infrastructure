resource "aws_security_group" "kafka_test" {

  name        = "kafka_test-${var.deployment_identifier}"
  description = "Security group for Kafka test"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "kafka_test-${var.deployment_identifier}"
    )
  )}"
}

resource "aws_security_group_rule" "bastion_ssh" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.kafka_test.id}"
  source_security_group_id = "${var.bastion_security_group_id}"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  description              = "SSH from Bastion to Kafka test"
}

resource "aws_security_group_rule" "kafka_test_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.kafka_test.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Unrestricted egress for Kafka test"
}

resource "aws_security_group_rule" "kafka_test_emr_ingress_broker" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.kafka_test.id}"
  source_security_group_id = "${var.emr_security_group_id}"
  from_port                = 9092
  to_port                  = 9092
  protocol                 = "tcp"
  description              = "Kafka test broker ingress for EMR cluster"
}

resource "aws_security_group_rule" "kafka_test_emr_ingress_zookeeper" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.kafka_test.id}"
  source_security_group_id = "${var.emr_security_group_id}"
  from_port                = 2181
  to_port                  = 2181
  protocol                 = "tcp"
  description              = "test Zookeeper ingress for EMR cluster"
}
