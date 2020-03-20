output "airflow_2_address" {
  description = "The DNS address of the airflow instance."
  value       = "${module.training_airflow_2.airflow_2_address}"
}
