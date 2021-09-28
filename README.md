# Mango Deck Infrastructure

- [Mango Deck Infrastructure](#mango-deck-infrastructure)
  - [TODO](#todo)
  - [Deploy environments](#deploy-environments)
    - [Terragrunt](#terragrunt)
    - [Deploy all environments](#deploy-all-environments)
    - [Deploy Development Environment](#deploy-development-environment)
    - [Deploy Staging Environment](#deploy-staging-environment)
  - [Order of dependencies](#order-of-dependencies)
    - [1. Cloudwatch Billing Alarm](#1-cloudwatch-billing-alarm)
    - [2. Route53 Hosted Zone](#2-route53-hosted-zone)
    - [3. Auth Route53 A Record](#3-auth-route53-a-record)
    - [4. AWS ACM Certificate](#4-aws-acm-certificate)
    - [5. S3 Bucket for Static Frontend](#5-s3-bucket-for-static-frontend)
    - [6. Cloudfront Distribution](#6-cloudfront-distribution)
    - [7. Cloudfront Alias Record](#7-cloudfront-alias-record)
    - [8. Post Confirmation Lambda S3 Bucket](#8-post-confirmation-lambda-s3-bucket)
    - [9. Create a `function.zip`](#9-create-a-functionzip)
    - [10. Post Confirmation Lambda](#10-post-confirmation-lambda)
    - [11. Cognito User Pool](#11-cognito-user-pool)
    - [12. Lambda Cognito Trigger Permissions](#12-lambda-cognito-trigger-permissions)
    - [13. Cognito User Pool Domain](#13-cognito-user-pool-domain)
    - [13. Appsync graphql](#13-appsync-graphql)
    - [13. Secrets Manager Secret](#13-secrets-manager-secret)
    - [14. Secrets Manager Secret Version](#14-secrets-manager-secret-version)

## TODO

[ ] - Create a default `function.zip` file to upload as lambda `bucket_key`.
[ ] - Create a default `index.html` file to upload as defaul static website in S3.

## Deploy environments

### Terragrunt

Terragrunt is a wrapper library around Terraform that adds some nice-to-have functionality.

- Treats each directory with a `terragrunt.hcl` file as it's own **terraform state**.

- You do not have to drill down vairable inputs they can be declared only once and can be referenced throughout globaly by using the `find_in_parent_folders` method
  
- All terraform commands are available via `terragrunt <command>`

- Running `terragrunt run-all <command>` will execute the command recursively throughout all child modules.

**IMPORTANT! Read these gotchas:**

- `terragrunt run-all apply` **WILL NOT** prompt you to confirm before applying. However running `terragrunt apply` within a singel module will prompt you to confirm.


### Deploy all environments

```shell
cd sandbox
terragrunt run-all apply
```

### Deploy Development Environment

```shell
cd sandbox/development
terragrunt run-all apply
```

### Deploy Staging Environment

```shell
cd sandbox/staging
terragrunt run-all apply
```

**Deploy Modules:**

```shell
cd sandbox/development/cognito/user_pool
terragrunt apply
```

## Order of dependencies

### 1. Cloudwatch Billing Alarm

**Dependencies:**

- no dependencies

### 2. Route53 Hosted Zone

**Dependencies:**

- no dependencies

**Note: When creating a new hosted zone you will have to update the NS on the registered domain to point to the new NS on the hosted zone. This has to be done manually since Terraform does not support Domain Registry actions.**

### 3. Auth Route53 A Record

**Dependencies:**

- aws_route53_hosted_zone

### 4. AWS ACM Certificate

**Dependencies:**

- aws_route53_hosted_zone

### 5. S3 Bucket for Static Frontend

**Dependencies:**

- no dependencies

### 6. Cloudfront Distribution

**Dependencies:**

- aws_route53_hosted_zone
- aws_s3_bucket

### 7. Cloudfront Alias Record

**Dependencies:**

- aws_route53_hosted_zone
- aws_cloudfront_distribution

### 8. Post Confirmation Lambda S3 Bucket

**Dependencies:**

- no dependencies

### 9. Create a `function.zip`

**Dependencies:**

- post_confirmation_lambda_s3_bucket

**Note**

- This is a manual step for the time being.
- Create a `function.zip` and upload it to the previsouly made Lambda S3 bucket

### 10. Post Confirmation Lambda

**Dependencies:**

- post_confirmation_lambda_bucket
- `function.zip` bucket_key

### 11. Cognito User Pool

**Dependencies:**

- aws_route53_hosted_zone
- post_confirmation_lambda

### 12. Lambda Cognito Trigger Permissions

**Dependencies:**

- post_confirmation_lambda
- cognito_user_pool

### 13. Cognito User Pool Domain

**Dependencies:**

- cognito_user_pool
- auth_alias_record

### 13. Appsync graphql

**Dependencies:**

- cognito_user_pool
  
### 13. Secrets Manager Secret

**Dependencies:**

- no dependencies

### 14. Secrets Manager Secret Version

- secrets_manager_secret
