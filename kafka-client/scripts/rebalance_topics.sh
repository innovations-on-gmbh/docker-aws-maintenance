#!/bin/bash
set -eou pipefail

#NOTE: this is a potentially destructive script, hence it's not automatically copied to the docker image

#TODOs before running:
#update ZKHOST
#output of the script, copy the new assignment part to a file named /new_assignment.json
#then start rebalancing and check progress with commented out parts below

THROTTLE=100000

apt update && apt install -y jq



ZKHOST="z-3.devonpier-kafka.gereae.c1.kafka.eu-central-1.amazonaws.com:2181"
echo "Collecting topic names..."
TOPICJSON="{\"topics\":["
for topic in $(kafka-topics.sh --command-config /config.properties --bootstrap-server "$BOOTSTRAP" --list); do
    TOPICJSON+="{\"topic\":\"${topic}\"},"
done
TOPICJSON=${TOPICJSON:0:-1}
TOPICJSON+="],\"version\":1}"
echo "${TOPICJSON}" | jq -c . > /tmp/topics.json

jq -c . < /tmp/topics.json

BROKERLIST=$(zookeeper-shell.sh "$ZKHOST" <<< "ls /brokers/ids" | grep -Evi "watch|zoo|jline|connect" | jq -c . | tr -d "[]")
echo "$BROKERLIST"
echo "Building new partition layout..."

KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:log4j.properties"
KAFKA_HEAP_OPTS="-Xms512m -Xmx4g"

kafka-reassign-partitions.sh --command-config /config.properties --bootstrap-server "$BOOTSTRAP" --broker-list "${BROKERLIST}" --topics-to-move-json-file /tmp/topics.json --generate
#TODO awk solution doesn't work, hence manual stuff -> fix it if needed ;-)
#awk '/Proposed partition reassignment configuration/,0' | grep -v "Proposed partition reassignment configuration" | jq -c . > /tmp/newtopiclayout.json

#TODO start rebalancing command
# echo "Re-assigning partitions..."
# kafka-reassign-partitions.sh --command-config /config.properties --bootstrap-server "$BOOTSTRAP" --reassignment-json-file new_assignment.json --throttle "${THROTTLE}" --execute

#TODO check progress command, output is number of topics still to be rebalanced
# sleep 300
# INPROGRESS=$(kafka-reassign-partitions.sh --command-config /config.properties --bootstrap-server "$BOOTSTRAP" --reassignment-json-file /new_assignment.json --verify | grep -c "is still in progress")
# while [ "${INPROGRESS}" -gt 0 ]; do
#     echo "Waiting on ${INPROGRESS} partitions to re-replicate"
#     sleep 300
#     INPROGRESS=$(kafka-reassign-partitions.sh --command-config /config.properties --bootstrap-server "$BOOTSTRAP" --reassignment-json-file /new_assignment.json --verify | grep -c "is still in progress")
# done

# kafka-leader-election.sh --admin.config /config.properties --bootstrap-server "$BOOTSTRAP" --election-type preferred --path-to-json-file new_assignment.json

