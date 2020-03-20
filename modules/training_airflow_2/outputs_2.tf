output "airflow_2_address" {
  description = "The DNS address of the airflow instance."
  value       = "${aws_route53_record.airflow_2.fqdn}"
}
