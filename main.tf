data "vault_policy_document" "this" {
  rule {
    capabilities = ["update"]
    description  = "Allow creating tokens under nomad-cluster token role."
    path         = "auth/token/create/nomad-cluster"
  }
  rule {
    capabilities = ["read"]
    description  = "Allow looking up nomad-cluster token role."
    path         = "auth/token/roles/nomad-cluster"
  }
  rule {
    capabilities = ["read"]
    description  = "Allow looking up the token passed to Nomad to validate the token has the proper capabilities."
    path         = "auth/token/lookup-self"
  }
  rule {
    capabilities = ["update"]
    description  = "Allow looking up incoming tokens to validate they have permissions to access the tokens they are requesting."
    path         = "auth/token/lookup"
  }
  rule {
    capabilities = ["update"]
    description  = "Allow revoking tokens that should no longer exist."
    path         = "auth/token/revoke-accessor"
  }
  rule {
    capabilities = ["update"]
    description  = "Allow checking the capabilities of our own token."
    path         = "sys/capabilities-self"
  }
  rule {
    capabilities = ["update"]
    description  = "Allow our own token to be renewed."
    path         = "auth/token/renew-self"
  }
  rule {
    capabilities = ["create", "read", "update", "patch", "delete", "list"]
    description  = "Allow PKI issuer."
    path         = "pki/issue/consul"
  }
  rule {
    capabilities = ["create", "read", "update", "patch", "delete", "list"]
    description  = "Allow PKI issuer."
    path         = "pki/*"
  }
}

module "vault_policy" {
  source  = "pmikus/policy/vault"
  version = "3.14.0"

  policy_name   = "nomad-cluster"
  policy_policy = data.vault_policy_document.this.hcl
}

module "token-auth-backend-role" {
  source  = "pmikus/token-auth-backend-role/vault"
  version = "3.14.0"

  depends_on = [
    module.vault_policy
  ]

  token_auth_backend_role_allowed_policies       = ["nomad-cluster"]
  token_auth_backend_role_disallowed_policies    = ["default"]
  token_auth_backend_role_orphan                 = true
  token_auth_backend_role_renewable              = true
  token_auth_backend_role_role_name              = "nomad-cluster"
  token_auth_backend_role_token_explicit_max_ttl = 0
  token_auth_backend_role_token_period           = 259200
}

module "token" {
  source  = "pmikus/token/vault"
  version = "3.14.0"

  depends_on = [
    module.token-auth-backend-role
  ]

  token_policies  = ["nomad-cluster"]
  token_role_name = "nomad-cluster"
  token_ttl       = "72h"
}

module "mount" {
  source  = "pmikus/mount/vault"
  version = "3.14.0"

  mount_description               = "PKI secret backend"
  mount_path                      = "pki"
  mount_type                      = "pki"
}

module "pki-secret-backend-role" {
  source  = "pmikus/pki-secret-backend-role/vault"
  version = "3.14.0"

  depends_on = [
    module.mount
  ]

  pki_secret_backend_role_allow_ip_sans    = true
  pki_secret_backend_role_allow_localhost  = true
  pki_secret_backend_role_allow_subdomains = true
  pki_secret_backend_role_allowed_domains  = ["service.consul"]
  pki_secret_backend_role_backend          = module.mount.mount_path
  pki_secret_backend_role_key_bits         = 4096
  pki_secret_backend_role_key_type         = "rsa"
  pki_secret_backend_role_name             = "consul"
  pki_secret_backend_role_ttl              = 87600
}

resource "vault_pki_secret_backend_root_cert" "this" {
  depends_on = [
    module.mount
  ]

  backend              = module.mount.mount_path
  type                 = "internal"
  common_name          = "service.consul"
  format               = "pem"
  private_key_format   = "der"
  key_bits             = 4096
  key_type             = "ed25519"
  exclude_cn_from_sans = true
  ou                   = "Razer"
  organization         = "Home"
}