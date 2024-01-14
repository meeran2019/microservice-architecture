resource "aws_secretsmanager_secret" "master_password_secret" {
  name = "master-password-secret-1"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "master_password_version" {
  secret_id     = aws_secretsmanager_secret.master_password_secret.id
  secret_string = random_password.password.result
}

