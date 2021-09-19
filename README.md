# Mango Deck Infrastructure

## Deploy Environent

```shell
cd sandbox
terragrunt run-all apply
```

## Order of dependencies

### 1. Cloudwatch Billing Alarm

- no dependencies

### 2. Route53 Hosted Zone

- no dependencies

**Note: When creating a new hosted zone you will have to update the NS on the registered domain to point to the new NS on the hosted zone. This has to be done manually since Terraform does not support Domain Registry actions.**

### 3. Auth Route53 A Record

- aws_route53_hosted_zone

### 4. AWS ACM Certificate

- aws_route53_hosted_zone

### 5. S3 Bucket for Static Frontend

- no dependencies

### 6. Cloudfront Distribution

- aws_route53_hosted_zone
- aws_s3_bucket

### 7. Cloudfront Alias Record

- aws_route53_hosted_zone
- aws_cloudfront_distribution

### 8. Post Confirmation Lambda S3 Bucket

- no dependencies

### 9. Post Confirmation Lambda

- post_confirmation_lambda_bucket

### 10. Cognito User Pool

- aws_route53_hosted_zone
- post_confirmation_lambda

### 11. Cognito User Pool Domain

- cognito_user_pool
- auth_alias_record

### 12. Lambda Cognito Trigger Permissions

- post_confirmation_lambda
- cognito_user_pool
  