# output "fleet_membership" {
#   value       = google_container_azure_cluster.this.fleet[0].membership
# }

output "cluster_name" {
  value = google_container_azure_cluster.this.name
}
