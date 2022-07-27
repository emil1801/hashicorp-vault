resource "random_password" "random" {
  length           = 32
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
  upper            = false
}


resource "vault_generic_secret" "db" {
  path = "company_credentials/db"

  data_json = <<EOT
{
  "username":   "admin",
  "password": "${random_password.random.result}"
}
EOT
}