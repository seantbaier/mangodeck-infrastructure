locals {
  base_tags = {
    Envrionment = var.environment
    Name        = var.bucket
  }

  tags = local.base_tags
}


resource "aws_s3_bucket" "this" {
  count = var.create ? 1 : 0

  force_destroy = true
  bucket        = var.bucket
  acl           = var.acl



  dynamic "website" {
    for_each = length(keys(var.website)) == 0 ? [] : [var.website]

    content {
      index_document           = lookup(website.value, "index_document", null)
      error_document           = lookup(website.value, "error_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules            = lookup(website.value, "routing_rules", null)
    }
  }

  tags = local.tags
}



resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this[0].id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

data "aws_iam_policy_document" "this" {
  count = var.create_policy ? 1 : 0

  statement {
    actions   = var.actions
    resources = ["${aws_s3_bucket.this[0].arn}/*"]

    principals {
      type        = "AWS"
      identifiers = var.principals
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count = var.create_policy ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.this[0].json
}
