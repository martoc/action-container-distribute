# Code Style

## YAML Formatting

Code should be formatted using yamllint. The configuration file is located at `.yamllint` in the root of the repository.

### Running the Linter

```bash
yamllint action.yml .github/
```

### Key Guidelines

- Use 2 spaces for indentation
- Avoid trailing whitespace
- Use lowercase for keys
- Use descriptive names for workflow steps

## Shell Scripts

### Standalone Scripts

Shell scripts in the `scripts/` directory should follow these guidelines:

- Use `#!/usr/bin/env bash` shebang
- Enable strict mode: `set -euo pipefail`
- Use `readonly` for constants
- Include usage documentation in comments at the top of the script
- Use meaningful function and variable names
- Log messages should include the script name for traceability
- Exit with appropriate status codes (0 for success, non-zero for errors)

Example structure:

```bash
#!/usr/bin/env bash
#
# Script description here.
#
# Usage: script-name.sh <arg1> <arg2>
#

set -euo pipefail

readonly SCRIPT_NAME="$(basename "${0}")"

log_info() {
    echo "[INFO] ${SCRIPT_NAME}: ${1}"
}

log_error() {
    echo "[ERROR] ${SCRIPT_NAME}: ${1}" >&2
}

main() {
    # Implementation
}

main "${@}"
```

### Embedded Scripts in action.yml

The action contains embedded shell scripts in `action.yml`. Follow these guidelines:

- Use double quotes for variable expansion
- Check required variables with explicit error messages
- Exit with non-zero status on errors
- Use meaningful variable names
- Add comments for complex logic

## Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `chore:` for maintenance tasks

## Pull Requests

- Create feature branches from `main`
- Use descriptive branch names: `feat/description`, `fix/description`
- Ensure all linting checks pass before requesting review
