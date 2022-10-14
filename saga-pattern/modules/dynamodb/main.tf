resource "aws_dynamodb_table" "dynamodb" {
  name           = var.table_name
  billing_mode   = var.billing_mode
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  tags = merge(
    var.additional_tags,
    {
      Deployer = "terraform"
    }
  )
}