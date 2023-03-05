#!/bin/bash

set -eu

kafka-topics.sh --command-config /config.properties --bootstrap-server "$BOOTSTRAP" --delete --topic "$1"
