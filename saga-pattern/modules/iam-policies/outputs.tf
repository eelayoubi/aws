output "dynamo_db_read" {
  value = aws_iam_policy.dynamo_db_read.arn
}

output "dynamo_db_write" {
  value = aws_iam_policy.dynamo_db_write.arn
}
