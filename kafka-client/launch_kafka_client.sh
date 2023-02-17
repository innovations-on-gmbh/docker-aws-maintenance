#!/usr/bin/env bash
set -eu

#TODO check for credentials.yaml, have to be in tf-software-ic repo

kubectl run --rm -ti -n default mongo-client \
--image=ghcr.io/innovations-on-gmbh/docker-aws-maintenance/mongo-client:latest \
--env="PASSWORD=$(sops -d --extract '["documentdb"]["root_user"]["password"]["value"]' credentials.yaml)" \
--env="ENDPOINT=$(aws docdb describe-db-clusters --output text --query 'DBClusters[0].Endpoint')" \
--env="MASTER_USERNAME=$(aws docdb describe-db-clusters --output text --query 'DBClusters[0].MasterUsername')" \
--image-pull-policy=Always \
--overrides='{"metadata": {"annotations": { "linkerd.io/inject":"disabled" } } }' \
-- /bin/bash
