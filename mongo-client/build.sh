#!/usr/bin/env bash

set -exu

TAG=0.1

docker build --tag ghcr.io/innovations-on-gmbh/docker-aws-maintenance/mongo-client:"$TAG" .
