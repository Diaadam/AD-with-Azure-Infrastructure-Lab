@"
storage_account_name = "$(terraform output -raw storage_account_name)"
container_name       = "$(terraform output -raw storage_container_name)"
key                  = "<state_path>/terraform.tfstate"
client_id             = "$(terraform output -raw client_id)"
client_secret         = "$(terraform output -raw client_secret)"
tenant_id             = "$(terraform output -raw tenant_id)"
subscription_id       = "$(terraform output -raw subscription_id)"
"@ | Set-Content backend.tfbackend