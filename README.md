[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# action-container-distribute

A GitHub Action that copies container images between registries. Supports GCP Artifact Registry, AWS ECR and Azure Container Registry, in any combination of source and target.

## Features

- Copy container images between GCP Artifact Registry, AWS ECR and Azure Container Registry
- Any source to any target, including across cloud providers (for example AWS ECR to Azure)
- Keyless authentication everywhere: Workload Identity Federation for GCP, OIDC role assumption for AWS, OIDC federated credentials for Azure
- Fails fast on an unknown registry or missing Azure inputs, before any login

## Quick Start

### GCP to GCP

```yaml
- name: Distribute container image
  uses: martoc/action-container-distribute@v1
  with:
    source_registry: gcp
    source_workload_identity_provider: ${{ secrets.SOURCE_WIF_PROVIDER }}
    source_service_account: ${{ secrets.SOURCE_SERVICE_ACCOUNT }}
    source_region: us-central1
    source_gcp_project_id: source-project
    target_registry: gcp
    target_workload_identity_provider: ${{ secrets.TARGET_WIF_PROVIDER }}
    target_service_account: ${{ secrets.TARGET_SERVICE_ACCOUNT }}
    target_region: europe-west1
    target_gcp_project_id: target-project
    container_image: namespace/image:tag
```

### GCP to AWS ECR

```yaml
- name: Distribute container image to AWS
  uses: martoc/action-container-distribute@v1
  with:
    source_registry: gcp
    source_workload_identity_provider: ${{ secrets.SOURCE_WIF_PROVIDER }}
    source_service_account: ${{ secrets.SOURCE_SERVICE_ACCOUNT }}
    source_region: europe-west2
    source_gcp_project_id: source-project
    target_registry: aws
    target_aws_role_arn: ${{ secrets.AWS_ROLE_ARN }}
    target_region: eu-west-1
    container_image: namespace/image:tag
```

### AWS ECR to Azure Container Registry

```yaml
- name: Distribute container image to Azure
  uses: martoc/action-container-distribute@v1
  with:
    source_registry: aws
    source_aws_role_arn: ${{ vars.AWS_ROLE_ARN }}
    source_region: eu-west-1
    target_registry: azure
    target_azure_client_id: ${{ vars.AZURE_CLIENT_ID }}
    target_azure_tenant_id: ${{ vars.AZURE_TENANT_ID }}
    target_azure_subscription_id: ${{ vars.AZURE_SUBSCRIPTION_ID }}
    target_azure_registry_name: myregistry
    container_image: namespace/image:tag
```

## Documentation

- [Usage Guide](./docs/USAGE.md) - Detailed usage instructions and examples
- [Code Style](./docs/CODESTYLE.md) - Code style guidelines for contributors

## Inputs

| Input | Description | Required |
|-------|-------------|----------|
| `source_registry` | Source registry (`gcp`, `aws` or `azure`) | Yes |
| `source_workload_identity_provider` | GCP Workload Identity Provider | No |
| `source_service_account` | GCP Service Account | No |
| `source_region` | Source region | No |
| `source_gcp_project_id` | Source GCP Project ID | No |
| `source_aws_role_arn` | Source AWS IAM Role ARN for OIDC (account ID extracted automatically) | No |
| `source_azure_client_id` | Source Microsoft Entra application client ID for OIDC | No |
| `source_azure_tenant_id` | Source Microsoft Entra tenant ID | No |
| `source_azure_subscription_id` | Source Azure subscription containing the registry | No |
| `source_azure_registry_name` | Source Azure Container Registry name | No |
| `target_registry` | Target registry (`gcp`, `aws` or `azure`) | Yes |
| `target_workload_identity_provider` | GCP Workload Identity Provider | No |
| `target_service_account` | GCP Service Account | No |
| `target_region` | Target region | No |
| `target_gcp_project_id` | Target GCP Project ID | No |
| `target_aws_role_arn` | Target AWS IAM Role ARN for OIDC (account ID extracted automatically) | No |
| `target_azure_client_id` | Target Microsoft Entra application client ID for OIDC | No |
| `target_azure_tenant_id` | Target Microsoft Entra tenant ID | No |
| `target_azure_subscription_id` | Target Azure subscription containing the registry | No |
| `target_azure_registry_name` | Target Azure Container Registry name | No |
| `container_image` | Container image in format `[namespace]/[name]:[tag]` | Yes |

## Licence

This project is licenced under the MIT Licence - see the [LICENCE](LICENSE) file for details.
