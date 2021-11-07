output "aws_vpc_id" {
  description = "ARN of the actuated KMS key resource for cluster secret encryption"
  value       = aws_vpc.this.id
}
output "aws_subnet_pri_1" {
  description = "private subnet ID of control plane 1"
  value       = aws_subnet.private[0].id
}

output "aws_subnet_pri_2" {
  description = "private subnet ID of control plane 2"
  value       = aws_subnet.private[1].id
}
output "aws_subnet_pri_3" {
  description = "private subnet ID of control plane 3"
  value       = aws_subnet.private[2].id
}

output "aws_subnet_pri_4" {
  description = "private subnet ID of node pools"
 value       = aws_subnet.private[3].id
}

output "aws_subnet_public" {
  description = "public subnet ID of routable"
  value       = aws_subnet.public.id
}

