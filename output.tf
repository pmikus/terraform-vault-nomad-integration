output "token_client_token" {
  sensitive = true
  value     = module.token.token_client_token
}

output "token_id" {
  value = module.token.token_id
}