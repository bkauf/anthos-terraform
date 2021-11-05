output "role_arn" {
  description = "ARN of the actuated IAM role resource"
  value       = aws_iam_role.this.arn
}