output "dynamo_db_delete" {
  value = aws_iam_policy.dynamo_db_delete.arn
}

output "dynamo_db_write" {
  value = aws_iam_policy.dynamo_db_write.arn
}
