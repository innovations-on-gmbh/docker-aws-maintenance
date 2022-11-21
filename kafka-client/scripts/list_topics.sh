#!/usr/bin/env bash
set -eu

kafka-topics.sh --list --command-config /config.properties --bootstrap-server "$BOOTSTRAP"
