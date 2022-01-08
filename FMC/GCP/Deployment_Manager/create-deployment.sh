#!/usr/bin/env bash
set -eu

gcloud deployment-manager deployments create fmc \
    --config examples/cisco_fmc_new.yaml

gcloud deployment-manager deployments create fmc \
    --config examples/cisco_fmc_existing.yaml