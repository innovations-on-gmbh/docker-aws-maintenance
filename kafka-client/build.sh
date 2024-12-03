#!/usr/bin/env bash

set -exu

TAG=0.5
REPO=ghcr.io/pcg-gcp/docker-gcp-maintenance/kafka-client

docker build --platform=linux/amd64 --tag "$REPO":"$TAG" --tag "$REPO":latest .
