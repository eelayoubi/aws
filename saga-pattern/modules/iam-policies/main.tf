resource "aws_iam_policy" "dynamo_db_delete" {
  name   = "${var.name}_delete_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.dynamo_db_delete.json
}

resource "aws_iam_policy" "dynamo_db_write" {
  name   = "${var.name}_write_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.dynamo_db_write.json
}
