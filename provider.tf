provider "vault" {
  address = "https://vault.tazhibaev.com"
  token = "${{ secrets.VAULT_TOKEN }}"
  skip_tls_verify = true
}

