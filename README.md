<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | 3.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.14.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mount"></a> [mount](#module\_mount) | pmikus/mount/vault | 3.14.0 |
| <a name="module_pki-secret-backend-role"></a> [pki-secret-backend-role](#module\_pki-secret-backend-role) | pmikus/pki-secret-backend-role/vault | 3.14.0 |
| <a name="module_token"></a> [token](#module\_token) | pmikus/token/vault | 3.14.0 |
| <a name="module_token-auth-backend-role"></a> [token-auth-backend-role](#module\_token-auth-backend-role) | pmikus/token-auth-backend-role/vault | 3.14.0 |
| <a name="module_vault_policy"></a> [vault\_policy](#module\_vault\_policy) | pmikus/policy/vault | 3.14.0 |

## Resources

| Name | Type |
|------|------|
| [vault_pki_secret_backend_root_cert.this](https://registry.terraform.io/providers/hashicorp/vault/3.14.0/docs/resources/pki_secret_backend_root_cert) | resource |
| [vault_policy_document.this](https://registry.terraform.io/providers/hashicorp/vault/3.14.0/docs/data-sources/policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vault_provider_address"></a> [vault\_provider\_address](#input\_vault\_provider\_address) | Vault cluster address. | `string` | `"http://vault.service.consul:8200"` | no |
| <a name="input_vault_provider_skip_tls_verify"></a> [vault\_provider\_skip\_tls\_verify](#input\_vault\_provider\_skip\_tls\_verify) | Verification of the Vault server's TLS certificate | `bool` | `false` | no |
| <a name="input_vault_provider_token"></a> [vault\_provider\_token](#input\_vault\_provider\_token) | Vault root token | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_token_client_token"></a> [token\_client\_token](#output\_token\_client\_token) | n/a |
| <a name="output_token_id"></a> [token\_id](#output\_token\_id) | n/a |
<!-- END_TF_DOCS -->