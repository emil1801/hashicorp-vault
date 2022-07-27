output "result" {
    value = "${random_password.random.result}"
    sensitive = true
}