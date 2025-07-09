#!/usr/bin/env bash
set -eu

mongosh mongodb://"$MASTER_USERNAME":"$PASSWORD"@"$ENDPOINT":27017/?ssl=true\&retryWrites=false --tlsCAFile global-bundle.pem --tls
