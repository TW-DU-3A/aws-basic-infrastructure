output "kafka_test_address" {
  description = "The DNS address of the Kafka test node."
  value       = "${module.training_kafka_test.kafka_test_address}"
}

output "kafka_test_security_group_id" {
  description = "Security group of Kafka test instance."
  value       = "${module.training_kafka_test.kafka_test_security_group_id}"
}

output "kafka_test_instance_id" {
  description = "The instance id."
  value       = "${module.training_kafka_test.kafka_test_instance_id}"
}
