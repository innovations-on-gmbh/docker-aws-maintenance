#!/usr/bin/env bash
set -eu


kafka-consumer-groups.sh --list \
    --all-groups \
    --command-config /config.properties \
    --bootstrap-server "$BOOTSTRAP"
