output "policy_arn" {
  description = "The ARN assigned by AWS to this policy."
  value       = aws_iam_policy.additional_inline[0].arn
}
