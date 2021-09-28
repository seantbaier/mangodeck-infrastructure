resource "aws_secretsmanager_secret_version" "this" {
  for_each      = { for k, v in var.secrets : k => v }
  secret_id     = each.key
  secret_string = lookup(each.value, "secret_string", null) != null ? lookup(each.value, "secret_string", null) : (lookup(each.value, "secret_key_value", null) != null ? jsonencode(lookup(each.value, "secret_key_value", {})) : null)
}
