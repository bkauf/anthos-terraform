output "fleet_membership" {
  value = google_container_aws_cluster.this.fleet[0].membership
}
output "aws_region" {
  value = google_container_aws_cluster.this.aws_region
}
output "subnet_ids" {
  value = google_container_aws_cluster.this.control_plane[0].subnet_ids
}
