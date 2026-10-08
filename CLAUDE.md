# Claude Code Instructions

## Project Overview

This is a GitHub Action that copies container images between registries. It supports:

- **GCP Artifact Registry**: Using Workload Identity Federation for authentication
- **AWS ECR**: Using OIDC authentication with IAM role assumption
- **Azure Container Registry**: Using OIDC federated credentials via `azure/login`, then `az acr login`

## Key Files

- `action.yml` - Main action definition (composite action)
- `.github/workflows/validation.yml` - Credential-free CI exercising input validation
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

Every source/target pair works (GCP, AWS and Azure, on either side).

- **Each pull step writes `SOURCE_IMAGE`** (the fully qualified reference) to `$GITHUB_ENV`, and **each push step retags from it.** Keep that contract when adding a registry. Do not build the source URI again inside a push step: that is how AWS-to-GCP used to be impossible, because the GCP push step only fired when the source was also GCP.
- **`Validate inputs` runs first** and rejects an unknown registry value or incomplete Azure inputs. Every later step is gated on the registry value, so a typo would otherwise skip all of them and report success having copied nothing.
- **Inputs reach shell steps through `env:`, never by interpolating `${{ }}` into `run:`**, which prevents script injection.
- **Run scripts must parse under bash 3.2** (macOS runners use `/bin/bash`), so avoid `${var,,}`, `mapfile` and the like. Check with `/bin/bash -n`.

### AWS ECR Notes

- ECR requires repositories to exist before pushing images. The action does not create them; use an ECR repository creation template with `CREATE_ON_PUSH`
- ECR image scanning on push is deprecated and should not be enabled

### Azure Container Registry Notes

- **Read the login server with `az acr show --query loginServer`; never hardcode `.azurecr.io`.** The suffix differs in sovereign clouds.
- **`az acr login` and `az acr show` need ARM read on the registry.** `AcrPull` and `AcrPush` alone are not enough, so the identity also needs `Reader`. `Contributor` covers both.
- **Source and target each run their own `azure/login`,** so they can use different identities, tenants and subscriptions. Docker keeps both registry logins.

### Adding New Registry Support

To add support for a new registry:

1. Add input parameters to `action.yml` (both source and target)
2. Add authentication step using appropriate GitHub Action
3. Add pull step with registry-specific login, exporting `SOURCE_IMAGE` to `$GITHUB_ENV`
4. Add push step with registry-specific login that retags from `SOURCE_IMAGE`
5. Accept the new value in the `Validate inputs` step, and add a rejection case to `.github/workflows/validation.yml`
6. Update documentation in `docs/USAGE.md` and `README.md`
