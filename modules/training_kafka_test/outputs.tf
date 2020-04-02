output "kafka_test_address" {
  description = "The DNS address of the kafka instance."
  value       = "${aws_route53_record.kafka_test.fqdn}"
}

output "kafka_test_security_group_id" {
  description = "Security group of Kafka test instance."
  value       = "${aws_security_group.kafka_test.id}"
}

output "kafka_test_instance_id" {
  description = "The instance id."
  value       = "${aws_instance.kafka_test.id}"
}
