#!/bin/bash
set -eu

#NOTE: this is a potentially desctructive script, hence it's not automatically copied to the docker image

#TODOs to run this script
#update dns zone to current cluster
#remove CLIENT_SECURE (only needed in clusters with TLS auth enabled, e.g. devonpier)

DNS_ZONE=devonpier-kafka.gereae.c1.kafka.eu-central-1.amazonaws.com

for i in {1..3}; do
    until kafka-configs.sh \
        --bootstrap-server "b-$i.$DNS_ZONE:9096" \
        --entity-type brokers \
        --entity-name "$i" \
        --alter \
        --command-config /config.properties \
        --add-config advertised.listeners=[CLIENT_SECURE://b-"$i".$DNS_ZONE:901"$i",CLIENT_SASL_SCRAM://b-"$i".$DNS_ZONE:900"$i",REPLICATION://b-"$i"-internal.$DNS_ZONE:9093,REPLICATION_SECURE://b-"$i"-internal.$DNS_ZONE:9095]
    do
        echo "retrying"
    done
 done
