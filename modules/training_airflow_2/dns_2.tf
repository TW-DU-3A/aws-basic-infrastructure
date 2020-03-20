resource "aws_route53_record" "airflow_2" {
  zone_id = "${var.dns_zone_id}"
  name    = "airflow_2"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_instance.airflow_2.private_dns}"]
}

# TODO: CNAME onto RDS
