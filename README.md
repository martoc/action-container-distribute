[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# action-container-distribute

A GitHub Action that copies container images between registries. Currently supports GCP Artifact Registry for both source and target registries.

## Features

- Copy container images between GCP Artifact Registry instances
- Workload Identity Federation support for secure authentication
- Cross-region and cross-project image distribution

## Quick Start

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

## Documentation

- [Usage Guide](./docs/USAGE.md) - Detailed usage instructions and examples
- [Code Style](./docs/CODESTYLE.md) - Code style guidelines for contributors

## Inputs

| Input | Description | Required |
|-------|-------------|----------|
| `source_registry` | Source registry (e.g., `gcp`) | Yes |
| `source_workload_identity_provider` | Source Workload Identity Provider | No |
| `source_service_account` | Source Service Account | No |
| `source_region` | Source region | No |
| `source_gcp_project_id` | Source GCP Project ID | No |
| `target_registry` | Target registry (e.g., `gcp`) | Yes |
| `target_workload_identity_provider` | Target Workload Identity Provider | No |
| `target_service_account` | Target Service Account | No |
| `target_region` | Target region | No |
| `target_gcp_project_id` | Target GCP Project ID | No |
| `container_image` | Container image in format `[namespace]/[name]:[tag]` | Yes |

## Licence

This project is licenced under the MIT Licence - see the [LICENCE](LICENSE) file for details.
