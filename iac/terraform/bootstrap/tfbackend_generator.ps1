@"
resource_group_name  = "$(terraform output -raw storage_resource_group_name)"
storage_account_name = "$(terraform output -raw storage_account_name)"
container_name       = "$(terraform output -raw storage_container_name)"
key                  = "$(terraform output -raw state_path)"
use_azuread_auth     = true
use_oidc             = true
oidc_cp_client_id    = "$(terraform output -raw oidc_srv_principal_client_id)"
oidc_cp_tenant_id    = "$(terraform output -raw oidc_srv_principal_tenant_id)"
storage_cp_client_id = "$(terraform output -raw storage_srv_principal_client_id)"
storage_cp_tenant_id = "$(terraform output -raw storage_srv_principal_tenant_id)"
subscription_id      = "$(terraform output -raw subscription_id)"
"@ | Set-Content backend.tfbackend