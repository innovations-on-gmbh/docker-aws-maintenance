#!/usr/bin/env bash
set -eu

#TODO check for credentials.yaml, have to be in tf-software-ic repo

kubectl run --rm -ti -n default kafka-client \
  --image=ghcr.io/pcg-gcp/docker-gcp-maintenance/kafka-client:latest \
  --env="BOOTSTRAP=$(gcloud managed-kafka clusters list --location=europe-west3 --format='get(BOOTSTRAP)' | tr -d '\n')" \
  --image-pull-policy=Always --overrides='{"metadata": {"annotations": { "linkerd.io/inject":"disabled" } } }' \
  -- /bin/bash
