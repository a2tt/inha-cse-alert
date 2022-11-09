output "aws_s3_bucket_name" {
  value = aws_s3_bucket.this.id
}

output "aws_dynamodb_table_name" {
  value = aws_dynamodb_table.this.id
}
