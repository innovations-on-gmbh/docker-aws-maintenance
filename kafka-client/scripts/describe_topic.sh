#!/usr/bin/env bash
set -eu

kafka-topics.sh --command-config /config.properties --bootstrap-server "$BOOTSTRAP" --describe --topic "$1"
