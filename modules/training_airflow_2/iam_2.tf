data "aws_iam_policy_document" "airflow_2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "airflow_2" {
  name               = "airflow_2-${var.deployment_identifier}"
  description        = "Role for Airflow to coordinate EMR jobs"
  assume_role_policy = "${data.aws_iam_policy_document.airflow_2_assume_role.json}"
}

resource "aws_iam_instance_profile" "airflow_2" {
  name = "airflow_2-${var.deployment_identifier}"
  role = "${aws_iam_role.airflow_2.name}"
}

data "aws_iam_policy_document" "airflow_2_emr" {
  statement {
    actions = [
      "elasticmapreduce:DescribeCluster",
      "elasticmapreduce:AddJobFlowSteps",
      "elasticmapreduce:DescribeStep"
    ]

    # For whatever mysterious reason, EMR doesn't support IAM resources
    resources = ["*"]

    # Use tags instead
    condition {
      test     = "StringEquals"
      variable = "elasticmapreduce:ResourceTag/Name"
      values   = ["${var.emr_cluster_name}"]
    }
  }
}

resource "aws_iam_policy" "airflow_2_emr" {
  name        = "airflow_2-emr-${var.deployment_identifier}"
  description = "Policy for Airflow to submit jobs to ${var.emr_cluster_name}"
  policy      = "${data.aws_iam_policy_document.airflow_2_emr.json}"
}

resource "aws_iam_policy_attachment" "airflow_2_emr" {
  name       = "airflow_2-emr-${var.deployment_identifier}"
  roles      = ["${aws_iam_role.airflow_2.name}"]
  policy_arn = "${aws_iam_policy.airflow_2_emr.arn}"
}

data "aws_iam_policy_document" "airflow_2_parameter_store" {
  statement {
    actions = [
      "ssm:GetParameters"
    ]

    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/${var.rds_snapshot_password_parameter}"
    ]
  }
}

resource "aws_iam_policy" "airflow_2_parameter_store" {
  name        = "airflow_2-parameter-store-${var.deployment_identifier}"
  description = "Policy allowng Airflow to read ${var.rds_snapshot_password_parameter} from Parameter Store"
  policy      = "${data.aws_iam_policy_document.airflow_2_parameter_store.json}"
}

resource "aws_iam_policy_attachment" "airflow_2_parameter_store" {
  name       = "airflow_2-parameter-store-${var.deployment_identifier}"
  roles      = ["${aws_iam_role.airflow_2.name}"]
  policy_arn = "${aws_iam_policy.airflow_2_parameter_store.arn}"
}
