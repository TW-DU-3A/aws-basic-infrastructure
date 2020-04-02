resource "aws_route53_record" "kafka_test" {
  zone_id = "${var.dns_zone_id}"
  name    = "kafka_test"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_instance.kafka_test.private_dns}"]
}
