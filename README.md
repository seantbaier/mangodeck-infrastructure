# mangodeck-infrastructure# Amz-allies-infrastructure

## Deploy Environent

```shell
terragrunt run-all apply
```

## Order of dependencies

### 1. Route53 Hosted Zone

- no dependencies

**Note: When creating a new hosted zone you will have to update the NS on the registered domain to point to the new NS on the hosted zone. This has to be done manually since Terraform does not support Domain Registry actions.**

### 2. AWS ACM Certificate

- aws_route53_hosted_zone

### 3. S3 Bucket for Static Frontend

- no dependencies

### 4. Cloudfront Distribution

- aws_route53_hosted_zone
- aws_s3_bucket

### 5. Post Confirmation Lambda S3 Bucket

### 6. Post Confirmation Lambda

