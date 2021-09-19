resource "aws_s3_bucket_policy" "this" {
  bucket = var.s3_bucket_id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "${var.environment}-${var.s3_bucket}-policy",
    "Statement" : [
      {
        "Sid" : "1",
        "Effect" : "Allow",
        "Principal" : {
          # "AWS" : "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E3BR036X2KYT65"
          "AWS" : var.cloudfront_origin_access_identity_arn

        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::testy-mctesterton/*"
      }
    ]
  })
}
