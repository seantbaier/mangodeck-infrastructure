data "aws_caller_identity" "current" {}


resource "aws_sns_topic" "billing_alarm_topic" {
  name = "${var.app_name}_billing_alarm_topic"

  delivery_policy = <<EOF
{
    "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false
  }
}
EOF
}

resource "aws_sns_topic_subscription" "billing_alarm_subscription" {
  topic_arn              = aws_sns_topic.billing_alarm_topic.arn
  protocol               = "email"
  endpoint               = "sean.t.baier@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = "${var.app_name}_billing_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600"
  statistic           = "Maximum"
  threshold           = "10"
  alarm_description   = "Billing alarm by account"
  alarm_actions       = [aws_sns_topic.billing_alarm_topic.arn]

  dimensions = {
    Currency      = "USD"
    LinkedAccount = data.aws_caller_identity.current.account_id
  }
}
