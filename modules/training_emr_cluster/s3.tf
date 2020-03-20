resource "aws_s3_bucket" "emr_logs" {
  bucket = "${var.deployment_identifier}-emr-logs"
  acl    = "private"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.deployment_identifier}-emr-logs"
    )
  )}"
}

resource "aws_s3_bucket" "emr_airflow_scripts" {
  bucket = "${var.deployment_identifier}-emr-airflow-scripts"
  acl    = "private"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.deployment_identifier}-emr-airflow-scripts"
    )
  )}"
}

resource "aws_s3_bucket_object" "install_airflow" {
  bucket = "${var.deployment_identifier}-emr-airflow-scripts"
  key    = "install_airflow.sh"
  source = "${path.module}/scripts/install_airflow.sh"
  #etag   = "${filemd5("${path.module}/install_airflow.sh")}"
}

resource "aws_s3_bucket_object" "start_airflow" {
  bucket = "${var.deployment_identifier}-emr-airflow-scripts"
  key    = "start_airflow.sh"
  source = "${path.module}/scripts/start_airflow.sh"
  #etag   = "${filemd5("${path.module}/start_airflow.sh")}"
}
