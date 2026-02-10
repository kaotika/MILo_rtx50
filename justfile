set shell := ["bash", "-c"]

REPO_URL := env("REPO_URL", "https://github.com/kaotika/MILo_rtx50")
IMAGE_NAME := env("IMAGE_NAME", "ghcr.io/kaotika/milo_rtx50")
JUST_DEBUG := env("JUST_DEBUG", "false")

@recipes:
    just --list --justfile {{ justfile() }}

docker-login USERNAME="kaotika":
    docker login --username {{USERNAME}} ghcr.io

_build-image PUSH="false" IMAGE_TAG="cuda_12.8-torch_2.7.1-ubuntu2404" DOCKERFILE="Dockerfile_cuda_12.8" REPO_URL=REPO_URL IMAGE_NAME=IMAGE_NAME:
    #!/usr/bin/env bash
    if {{ JUST_DEBUG }}; then
        set -euxo pipefail
    else
        set -e
    fi
    ARGS=()
    if {{ PUSH }}; then
        ARGS+=(--push)
    fi
    docker build --file {{ DOCKERFILE }} ${ARGS[@]} --build-arg REPO_URL={{ REPO_URL }} --tag {{ IMAGE_NAME }}:{{ IMAGE_TAG }} .

build-image-cuda130 PUSH="false" IMAGE_TAG="cuda_13.0-torch_2.9.1-ubuntu2404": (_build-image PUSH IMAGE_TAG "Dockerfile_cuda_13.0" REPO_URL IMAGE_NAME)
build-image-cuda128 PUSH="false" IMAGE_TAG="cuda_12.8-torch_2.7.1-ubuntu2404": (_build-image PUSH IMAGE_TAG "Dockerfile_cuda_12.8" REPO_URL IMAGE_NAME)
build-image-cuda124 PUSH="false" IMAGE_TAG="cuda_12.4-torch_2.5.1-ubuntu2204": (_build-image PUSH IMAGE_TAG "Dockerfile_cuda_12.4" REPO_URL IMAGE_NAME)
