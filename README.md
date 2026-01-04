[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# action-container-distribute

A GitHub Action that copies container images between registries. Supports GCP Artifact Registry and AWS ECR.

## Features

- Copy container images between GCP Artifact Registry instances
- Copy container images between AWS ECR registries
- Cross-cloud migration: GCP to AWS ECR
- Workload Identity Federation support for GCP authentication
- OIDC authentication for AWS
- Automatic ECR repository creation when pushing to AWS

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
    target_aws_account_id: ${{ secrets.AWS_ACCOUNT_ID }}
    container_image: namespace/image:tag
```

## Documentation

- [Usage Guide](./docs/USAGE.md) - Detailed usage instructions and examples
- [Code Style](./docs/CODESTYLE.md) - Code style guidelines for contributors

## Inputs

| Input | Description | Required |
|-------|-------------|----------|
| `source_registry` | Source registry (`gcp` or `aws`) | Yes |
| `source_workload_identity_provider` | GCP Workload Identity Provider | No |
| `source_service_account` | GCP Service Account | No |
| `source_region` | Source region | No |
| `source_gcp_project_id` | Source GCP Project ID | No |
| `source_aws_account_id` | Source AWS Account ID | No |
| `source_aws_role_arn` | Source AWS IAM Role ARN for OIDC | No |
| `target_registry` | Target registry (`gcp` or `aws`) | Yes |
| `target_workload_identity_provider` | GCP Workload Identity Provider | No |
| `target_service_account` | GCP Service Account | No |
| `target_region` | Target region | No |
| `target_gcp_project_id` | Target GCP Project ID | No |
| `target_aws_account_id` | Target AWS Account ID | No |
| `target_aws_role_arn` | Target AWS IAM Role ARN for OIDC | No |
| `container_image` | Container image in format `[namespace]/[name]:[tag]` | Yes |

## Licence

This project is licenced under the MIT Licence - see the [LICENCE](LICENSE) file for details.
