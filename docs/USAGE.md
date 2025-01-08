# Usage

## Distribute a Container Image

This GitHub Action copies a container image to multiple registries.

## Inputs

| Name                                | Description                                                                  | Required | Default |
| ----------------------------------- | ---------------------------------------------------------------------------- | -------- | ------- |
| `source_registry`                   | Source registry                                                              | true     |         |
| `source_workload_identity_provider` | Workload Identity Provider                                                   | false    |         |
| `source_service_account`            | Service Account                                                              | false    |         |
| `source_region`                     | Region to pull the container from. Valid values: Google Cloud or AWS regions | false    | ""      |
| `source_gcp_project_id`             | Google Cloud Project ID                                                      | false    | ""      |
| `target_registry`                   | Target registry                                                              | true     |         |
| `target_workload_identity_provider` | Workload Identity Provider                                                   | false    |         |
| `target_service_account`            | Service Account                                                              | false    |         |
| `target_region`                     | Region to push the container to. Valid values: Google Cloud or AWS regions   | false    | ""      |
| `target_gcp_project_id`             | Google Cloud Project ID                                                      | false    | ""      |
| `container_image`                   | Container image in the format: `[namespace]/[name]:[tag]`                    | true     |         |

## Usage

```yaml
name: Distribute Container Image

on: [push]

jobs:
    distribute:
        runs-on: ubuntu-latest
        steps:
            - name: Checkout code
              uses: actions/checkout@v2

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
