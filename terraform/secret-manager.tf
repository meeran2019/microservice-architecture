resource "aws_secretsmanager_secret" "master_password_secret" {
  name = "master-password-secret"
}

resource "aws_secretsmanager_secret_version" "master_password_version" {
  secret_id     = aws_secretsmanager_secret.master_password_secret.id
  secret_string = random_password.password.result
}

