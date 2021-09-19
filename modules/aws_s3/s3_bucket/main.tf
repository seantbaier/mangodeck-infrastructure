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

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
