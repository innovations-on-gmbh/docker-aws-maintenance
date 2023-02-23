#!/usr/bin/env bash
set -eu

#TODO check for credentials.yaml, have to be in tf-software-ic repo

kubectl run --rm -ti -n default kafka-client \
  --image=ghcr.io/innovations-on-gmbh/docker-aws-maintenance/kafka-client:latest \
  --env="CONFIG_USER=$(sops -d --extract '["kafka"]["config_user"]["password"]' credentials.yaml)" \
  --env="BOOTSTRAP=$(aws kafka list-clusters-v2 --output text --query 'ClusterInfoList[*].ClusterArn' | xargs -I {} aws kafka get-bootstrap-brokers --cluster-arn {} --output text)" \
  --env="CLUSTER_ARN=$(aws kafka list-clusters-v2 --output text --query 'ClusterInfoList[*].ClusterArn')" \
  --image-pull-policy=Always --overrides='{"metadata": {"annotations": { "linkerd.io/inject":"disabled" } } }' \
  -- /bin/bash
