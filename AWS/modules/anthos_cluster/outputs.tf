# output "fleet_membership" {
#   value       = google_container_aws_cluster.this.fleet[0].membership
# }

output "cluster_name" {
  value = google_container_aws_cluster.this.name
}