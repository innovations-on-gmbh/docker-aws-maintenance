#!/bin/bash
set -eu

DNS_ZONE=prodonpierkafka.sifyfu.c6.kafka.eu-central-1.amazonaws.com

for i in {1..3}; do
    until kafka-configs.sh \
        --bootstrap-server "b-$i.$DNS_ZONE:9096" \
        --entity-type brokers \
        --entity-name "$i" \
        --alter \
        --command-config /config.properties \
        --add-config advertised.listeners=[CLIENT_SASL_SCRAM://b-"$i".$DNS_ZONE:900"$i",REPLICATION://b-"$i"-internal.$DNS_ZONE:9093,REPLICATION_SECURE://b-"$i"-internal.$DNS_ZONE:9095]
    do
        echo "retrying"
    done
 done
