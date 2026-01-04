# Claude Code Instructions

## Project Overview

This is a GitHub Action that copies container images between registries. It supports:

- **GCP Artifact Registry**: Using Workload Identity Federation for authentication
- **AWS ECR**: Using OIDC authentication with IAM role assumption

## Key Files

- `action.yml` - Main action definition (composite action)
- `scripts/ecr-ensure-repository.sh` - Script to create ECR repositories if they don't exist
- `docs/USAGE.md` - Detailed usage documentation
- `docs/CODESTYLE.md` - Code style guidelines

## Development Guidelines

### Testing Changes

This is a composite GitHub Action, so testing requires:

1. Push changes to a branch
2. Reference the branch in a workflow
3. Run the workflow to test

### Code Style

- Follow yamllint configuration in `.yamllint`
- Use British English in code, comments, and documentation
- Shell scripts must use strict mode (`set -euo pipefail`)

### Supported Registry Combinations

| Source | Target | Status |
|--------|--------|--------|
| GCP    | GCP    | Supported |
| GCP    | AWS    | Supported |
| AWS    | AWS    | Supported |
| AWS    | GCP    | Not yet implemented |

### AWS ECR Notes

- ECR requires repositories to exist before pushing images
- The `scripts/ecr-ensure-repository.sh` script handles automatic repository creation
- ECR image scanning on push is deprecated and should not be enabled

### Adding New Registry Support

To add support for a new registry:

1. Add input parameters to `action.yml` (both source and target)
2. Add authentication step using appropriate GitHub Action
3. Add pull step with registry-specific login
4. Add push step with registry-specific login and image URI format
5. Update documentation in `docs/USAGE.md` and `README.md`
