#!/usr/bin/env bash

set -exu

TAG=0.1

docker build --platform=linux/amd64 --tag ghcr.io/innovations-on-gmbh/docker-aws-maintenance/kafka-client:"$TAG" .
