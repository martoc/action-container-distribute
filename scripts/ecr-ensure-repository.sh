#!/usr/bin/env bash
#
# Ensures an ECR repository exists, creating it if necessary.
#
# Usage: ecr-ensure-repository.sh <repository-name> <region> [image-tag-mutability]
#
# Arguments:
#   repository-name      Name of the ECR repository (required)
#   region               AWS region (required)
#   image-tag-mutability MUTABLE or IMMUTABLE (default: MUTABLE)
#
# Environment variables:
#   AWS credentials must be configured (via OIDC, environment variables, or AWS CLI profile)
#
# Exit codes:
#   0 - Repository exists or was created successfully
#   1 - Error occurred
#

set -euo pipefail

readonly SCRIPT_NAME="$(basename "${0}")"

log_info() {
    echo "[INFO] ${SCRIPT_NAME}: ${1}"
}

log_error() {
    echo "[ERROR] ${SCRIPT_NAME}: ${1}" >&2
}

usage() {
    echo "Usage: ${SCRIPT_NAME} <repository-name> <region> [image-tag-mutability]"
    echo ""
    echo "Arguments:"
    echo "  repository-name      Name of the ECR repository (required)"
    echo "  region               AWS region (required)"
    echo "  image-tag-mutability MUTABLE or IMMUTABLE (default: MUTABLE)"
    exit 1
}

ensure_repository() {
    local repository_name="${1}"
    local region="${2}"
    local image_tag_mutability="${3:-MUTABLE}"

    # Validate inputs
    if [[ -z "${repository_name}" ]]; then
        log_error "Repository name is required"
        usage
    fi

    if [[ -z "${region}" ]]; then
        log_error "Region is required"
        usage
    fi

    # Check if repository exists
    log_info "Checking if repository '${repository_name}' exists in region '${region}'..."

    if aws ecr describe-repositories \
        --repository-names "${repository_name}" \
        --region "${region}" \
        --output text \
        >/dev/null 2>&1; then
        log_info "Repository '${repository_name}' already exists"
        return 0
    fi

    # Create repository
    log_info "Creating repository '${repository_name}' in region '${region}'..."

    if aws ecr create-repository \
        --repository-name "${repository_name}" \
        --region "${region}" \
        --image-tag-mutability "${image_tag_mutability}" \
        --output text \
        >/dev/null; then
        log_info "Repository '${repository_name}' created successfully"
        return 0
    else
        log_error "Failed to create repository '${repository_name}'"
        return 1
    fi
}

main() {
    if [[ $# -lt 2 ]]; then
        log_error "Missing required arguments"
        usage
    fi

    ensure_repository "${@}"
}

main "${@}"
