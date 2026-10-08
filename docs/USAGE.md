# Usage

## Distribute a Container Image

This GitHub Action copies a container image between registries. It supports GCP Artifact Registry, AWS ECR and Azure Container Registry, and any of them can be the source or the target.

The pull step exports the fully qualified reference it pulled, and the push step retags from that. Every source/target pair therefore works, including cross-cloud copies in either direction.

## Inputs

| Name                                | Description                                                                   | Required | Default |
| ----------------------------------- | ----------------------------------------------------------------------------- | -------- | ------- |
| `source_registry`                   | Source registry (`gcp`, `aws` or `azure`)                                     | true     |         |
| `source_workload_identity_provider` | GCP Workload Identity Provider                                                | false    |         |
| `source_service_account`            | GCP Service Account                                                           | false    |         |
| `source_region`                     | Region to pull the container from. Valid values: Google Cloud or AWS regions  | false    | ""      |
| `source_gcp_project_id`             | Google Cloud Project ID                                                       | false    | ""      |
| `source_aws_role_arn`               | AWS IAM Role ARN for OIDC authentication (account ID extracted automatically) | false    | ""      |
| `source_azure_client_id`            | Client ID of the Microsoft Entra application to log in as (azure source)      | false    | ""      |
| `source_azure_tenant_id`            | Microsoft Entra tenant ID (azure source)                                      | false    | ""      |
| `source_azure_subscription_id`      | Azure subscription containing the registry (azure source)                     | false    | ""      |
| `source_azure_registry_name`        | Azure Container Registry name, without `.azurecr.io` (azure source)           | false    | ""      |
| `target_registry`                   | Target registry (`gcp`, `aws` or `azure`)                                     | true     |         |
| `target_workload_identity_provider` | GCP Workload Identity Provider                                                | false    |         |
| `target_service_account`            | GCP Service Account                                                           | false    |         |
| `target_region`                     | Region to push the container to. Valid values: Google Cloud or AWS regions    | false    | ""      |
| `target_gcp_project_id`             | Google Cloud Project ID                                                       | false    | ""      |
| `target_aws_role_arn`               | AWS IAM Role ARN for OIDC authentication (account ID extracted automatically) | false    | ""      |
| `target_azure_client_id`            | Client ID of the Microsoft Entra application to log in as (azure target)      | false    | ""      |
| `target_azure_tenant_id`            | Microsoft Entra tenant ID (azure target)                                      | false    | ""      |
| `target_azure_subscription_id`      | Azure subscription containing the registry (azure target)                     | false    | ""      |
| `target_azure_registry_name`        | Azure Container Registry name, without `.azurecr.io` (azure target)           | false    | ""      |
| `container_image`                   | Container image in the format: `[namespace]/[name]:[tag]`                     | true     |         |

## Usage Examples

### GCP to GCP

Copy a container image between GCP Artifact Registry instances:

```yaml
name: Distribute Container Image

on: [push]

jobs:
    distribute:
        runs-on: ubuntu-latest
        permissions:
            id-token: write
            contents: read
        steps:
            - name: Checkout code
              uses: actions/checkout@v6

            - name: Distribute container image
              uses: martoc/action-container-distribute@v1
              with:
                  source_registry: "gcp"
                  source_workload_identity_provider: "projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL_ID/providers/PROVIDER_ID"
                  source_service_account: "source-service-account@project-id.iam.gserviceaccount.com"
                  source_region: "us-central1"
                  source_gcp_project_id: "source-project-id"
                  target_registry: "gcp"
                  target_workload_identity_provider: "projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL_ID/providers/PROVIDER_ID"
                  target_service_account: "target-service-account@project-id.iam.gserviceaccount.com"
                  target_region: "europe-west1"
                  target_gcp_project_id: "target-project-id"
                  container_image: "namespace/image:tag"
```

### GCP to AWS ECR

Copy a container image from GCP Artifact Registry to AWS ECR:

```yaml
name: Distribute Container Image to AWS

on: [push]

jobs:
    distribute:
        runs-on: ubuntu-latest
        permissions:
            id-token: write
            contents: read
        steps:
            - name: Checkout code
              uses: actions/checkout@v6

            - name: Distribute container image
              uses: martoc/action-container-distribute@v1
              with:
                  source_registry: "gcp"
                  source_workload_identity_provider: "projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL_ID/providers/PROVIDER_ID"
                  source_service_account: "source-service-account@project-id.iam.gserviceaccount.com"
                  source_region: "europe-west2"
                  source_gcp_project_id: "source-project-id"
                  target_registry: "aws"
                  target_aws_role_arn: "arn:aws:iam::123456789012:role/github-actions-role"
                  target_region: "eu-west-1"
                  container_image: "namespace/image:tag"
```

### AWS ECR to AWS ECR

Copy a container image between AWS ECR registries:

```yaml
name: Distribute Container Image between AWS regions

on: [push]

jobs:
    distribute:
        runs-on: ubuntu-latest
        permissions:
            id-token: write
            contents: read
        steps:
            - name: Checkout code
              uses: actions/checkout@v6

            - name: Distribute container image
              uses: martoc/action-container-distribute@v1
              with:
                  source_registry: "aws"
                  source_aws_role_arn: "arn:aws:iam::123456789012:role/github-actions-role"
                  source_region: "us-east-1"
                  target_registry: "aws"
                  target_aws_role_arn: "arn:aws:iam::987654321098:role/github-actions-role"
                  target_region: "eu-west-1"
                  container_image: "my-app:v1.0.0"
```

### AWS ECR to Azure Container Registry

Copy a container image from AWS ECR to Azure Container Registry, for example to promote a build into a second cloud:

```yaml
name: Distribute Container Image to Azure

on: [push]

jobs:
    distribute:
        runs-on: ubuntu-latest
        permissions:
            id-token: write
            contents: read
        steps:
            - name: Distribute container image
              uses: martoc/action-container-distribute@v1
              with:
                  source_registry: "aws"
                  source_aws_role_arn: "arn:aws:iam::123456789012:role/github-actions-role"
                  source_region: "eu-west-1"
                  target_registry: "azure"
                  target_azure_client_id: "00000000-0000-0000-0000-000000000000"
                  target_azure_tenant_id: "00000000-0000-0000-0000-000000000000"
                  target_azure_subscription_id: "00000000-0000-0000-0000-000000000000"
                  target_azure_registry_name: "myregistry"
                  container_image: "my-app:v1.0.0"
```

The Azure inputs work the same way on the source side (`source_registry: "azure"` with the `source_azure_*` inputs). That covers Azure to AWS, Azure to GCP and Azure to Azure. The source and target can use different identities, tenants and subscriptions.

## Supported Combinations

| Source \ Target | GCP | AWS | Azure |
|---|---|---|---|
| **GCP** | Yes | Yes | Yes |
| **AWS** | Yes | Yes | Yes |
| **Azure** | Yes | Yes | Yes |

## AWS ECR Repositories

ECR needs a repository to exist before an image can be pushed into it, and the action does not create one. Use an [ECR repository creation template](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-creation-templates.html) with `CREATE_ON_PUSH`, or create the repository in advance. Artifact Registry and Azure Container Registry create repositories on first push.

## Authentication

### GCP Authentication

The action uses GCP Workload Identity Federation for authentication. Ensure your GitHub Actions workflow has the required permissions:

```yaml
permissions:
    id-token: write
    contents: read
```

### AWS Authentication

The action uses AWS OIDC authentication with IAM role assumption. Configure your AWS IAM role to trust GitHub's OIDC provider:

1. Create an IAM OIDC identity provider for GitHub Actions
2. Create an IAM role with the required ECR permissions
3. Configure the trust policy to allow your repository to assume the role

Required IAM permissions for ECR:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:CreateRepository"
            ],
            "Resource": "*"
        }
    ]
}
```

### Azure Authentication

The action logs in with [`azure/login`](https://github.com/Azure/login) using OpenID Connect, so no client secret is stored. Before you use it, register a federated identity credential on a Microsoft Entra application (or user-assigned managed identity) that trusts GitHub Actions:

- **Issuer:** `https://token.actions.githubusercontent.com`
- **Audience:** `api://AzureADTokenExchange`
- **Subject:** the token's `sub` claim, for example `repo:<owner>/<repo>:ref:refs/heads/main`. To trust several repositories or branches with one credential, use a [flexible federated identity credential](https://learn.microsoft.com/en-us/entra/workload-id/workload-identities-flexible-federated-identity-credentials). For GitHub, that credential must also match `repository_id` or `repository_owner_id`.

Grant the application these roles on the registry:

| Role | Why |
|---|---|
| `AcrPull` (source) or `AcrPush` (target) | Pulling or pushing the image |
| `Reader` | `az acr login` and `az acr show` look up the registry through Azure Resource Manager, and the `AcrPull` and `AcrPush` roles do not include that read |

`Contributor` or `Owner` on the registry already covers both rows. If the registry uses [ABAC repository permissions](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-rbac-abac-repository-permissions), use `Container Registry Repository Reader` or `Container Registry Repository Writer` in place of `AcrPull` or `AcrPush`.

The login server is read from the registry (`az acr show --query loginServer`) rather than assumed to be `<name>.azurecr.io`, so sovereign clouds such as Azure China (`azurecr.cn`) work unchanged.
