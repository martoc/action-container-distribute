# Usage

## Distribute a Container Image

This GitHub Action copies a container image to multiple registries. Supports GCP Artifact Registry and AWS ECR.

## Inputs

| Name                                | Description                                                                   | Required | Default |
| ----------------------------------- | ----------------------------------------------------------------------------- | -------- | ------- |
| `source_registry`                   | Source registry (`gcp` or `aws`)                                              | true     |         |
| `source_workload_identity_provider` | GCP Workload Identity Provider                                                | false    |         |
| `source_service_account`            | GCP Service Account                                                           | false    |         |
| `source_region`                     | Region to pull the container from. Valid values: Google Cloud or AWS regions  | false    | ""      |
| `source_gcp_project_id`             | Google Cloud Project ID                                                       | false    | ""      |
| `source_aws_account_id`             | AWS Account ID                                                                | false    | ""      |
| `source_aws_role_arn`               | AWS IAM Role ARN for OIDC authentication                                      | false    | ""      |
| `target_registry`                   | Target registry (`gcp` or `aws`)                                              | true     |         |
| `target_workload_identity_provider` | GCP Workload Identity Provider                                                | false    |         |
| `target_service_account`            | GCP Service Account                                                           | false    |         |
| `target_region`                     | Region to push the container to. Valid values: Google Cloud or AWS regions    | false    | ""      |
| `target_gcp_project_id`             | Google Cloud Project ID                                                       | false    | ""      |
| `target_aws_account_id`             | AWS Account ID                                                                | false    | ""      |
| `target_aws_role_arn`               | AWS IAM Role ARN for OIDC authentication                                      | false    | ""      |
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
              uses: actions/checkout@v4

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
              uses: actions/checkout@v4

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
                  target_aws_account_id: "123456789012"
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
              uses: actions/checkout@v4

            - name: Distribute container image
              uses: martoc/action-container-distribute@v1
              with:
                  source_registry: "aws"
                  source_aws_role_arn: "arn:aws:iam::123456789012:role/github-actions-role"
                  source_region: "us-east-1"
                  source_aws_account_id: "123456789012"
                  target_registry: "aws"
                  target_aws_role_arn: "arn:aws:iam::987654321098:role/github-actions-role"
                  target_region: "eu-west-1"
                  target_aws_account_id: "987654321098"
                  container_image: "my-app:v1.0.0"
```

## AWS ECR Repository Auto-Creation

When pushing to AWS ECR, the action automatically creates the repository if it does not exist. This is handled by the `scripts/ecr-ensure-repository.sh` script.

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
