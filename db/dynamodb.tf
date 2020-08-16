resource "aws_dynamodb_table" "basic-dynamodb-table" {

  name           = var.voddbname
  billing_mode   = var.dbbilling
  read_capacity  = var.readcap
  write_capacity = var.writecap
  hash_key       = var.hkey
  range_key      = var.rkey

  attribute {
    name = var.hkey
    type = var.atttype
  }

  attribute {
    name = var.rkey
    type = var.atttype

  }
}