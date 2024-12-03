#!/usr/bin/env bash
set -eu

cat <<EOT> /config.properties
security.protocol=SASL_SSL
sasl.mechanism=OAUTHBEARER
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required \
  username='script-runner@ic-pcg1-d-workload.iam.gserviceaccount.com';
EOT
