#!/usr/bin/env bash
set -eu

gcloud deployment-manager deployments create ftd \
    --config examples/single-instance.yaml