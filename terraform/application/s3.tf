# AWS S3
resource "aws_s3_bucket" "this" {
  bucket        = var.article_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

# IAM for Lambda to access S3
resource "aws_iam_policy" "access_s3" {
  name        = "${local.name_prefix}-policy-accessS3"
  path        = "/"
  description = "IAM policy for accessing to AWS S3"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
              "s3:PutObject",
              "s3:GetObject",
              "s3:ListBucket"
          ],
          "Resource": [
              "arn:aws:s3:::${var.article_bucket_name}",
              "arn:aws:s3:::${var.article_bucket_name}/*"
          ]
      }
  ]
}
  EOF
}

resource "aws_iam_role_policy_attachment" "access_s3" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.access_s3.arn
}
