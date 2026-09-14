```text
service_principal module
|-----oidc_srv_principal
|     └── Control-plane identity
|         └── GitHub OIDC federated authentication
|-----storage_srv_principal
|     └── Storage/backend identity
|         └── Conditional access to Terraform state blobs
```

```text

storage
└── remote storage creation including storage account, container, and access policies 

oidc module
└── Federated credentials for oidc_srv_principal
```