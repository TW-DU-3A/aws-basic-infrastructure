resource "aws_security_group" "airflow_2" {

  name        = "airflow_2-${var.deployment_identifier}"
  description = "Security group for Airflow 2"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "airflow_2-${var.deployment_identifier}"
    )
  )}"
}

resource "aws_security_group_rule" "bastion_ssh" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.airflow_2.id}"
  source_security_group_id = "${var.bastion_security_group_id}"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  description              = "SSH from Bastion to Airflow 2"
}

resource "aws_security_group_rule" "bastion_web" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.airflow_2.id}"
  source_security_group_id = "${var.bastion_security_group_id}"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  description              = "Allow Bastion to access Airflow 2 web UI"
}

resource "aws_security_group_rule" "airflow_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.airflow_2.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Unrestricted egress for Airflow 2"
}

resource "aws_security_group" "airflow_2_rds" {

  name        = "airflow_2-rds-${var.deployment_identifier}"
  description = "Security group for Airflow 2 RDS Postgres"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "airflow_2-rds-${var.deployment_identifier}"
    )
  )}"
}

resource "aws_security_group_rule" "airflow_2_rds" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.airflow_2_rds.id}"
  source_security_group_id = "${aws_security_group.airflow_2.id}"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  description              = "Allow Airflow 2 to connect to Postgres"
}
