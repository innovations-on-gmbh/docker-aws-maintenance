#!/usr/bin/env bash
set -eu

cat <<EOT> /config.properties
security.protocol=SASL_SSL
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required \
  username='config-admin' \
  password='$CONFIG_USER';
EOT
