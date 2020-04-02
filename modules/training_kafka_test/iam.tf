data "aws_iam_policy_document" "kafka_test_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "kafka_test" {
  name               = "kafka_test-${var.deployment_identifier}"
  description        = "Role for Kafka test"
  assume_role_policy = "${data.aws_iam_policy_document.kafka_test_assume_role.json}"
}

resource "aws_iam_instance_profile" "kafka_test" {
  name = "kafka_test-${var.deployment_identifier}"
  role = "${aws_iam_role.kafka_test.name}"
}

data "aws_iam_policy_document" "kafka_test_cloudwatch" {
  statement {
    actions = [
      "cloudwatch:PutMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "ec2:DescribeTags"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "kafka_test_cloudwatch" {
  name        = "kafka_test-emr-${var.deployment_identifier}"
  description = "Policy for kafka test to push data to cloudwatch"
  policy      = "${data.aws_iam_policy_document.kafka_test_cloudwatch.json}"
}

resource "aws_iam_policy_attachment" "kafka_test_cloudwatch" {
  name       = "kafka_test-emr-${var.deployment_identifier}"
  roles      = ["${aws_iam_role.kafka_test.name}"]
  policy_arn = "${aws_iam_policy.kafka_test_cloudwatch.arn}"
}
