data "aws_iam_policy_document" "this" {
  statement {
    actions   = var.actions
    resources = var.resources

    principals {
      type        = "AWS"
      identifiers = var.principals
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count = var.create ? 1 : 0

  bucket = var.s3_bucket_id
  policy = data.aws_iam_policy_document.this.json
}
