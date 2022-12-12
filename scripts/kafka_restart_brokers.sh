#!/bin/bash

#NOTE: run locally, not in image
#adapted from https://gist.github.com/ZachtimusPrime/1722cf058381fb9457832e4d92a06320

set -eu

function getRebootStatus () {
  arn=$(echo "$1" | tr -d '"')
  echo $(aws kafka describe-cluster-operation --cluster-operation-arn $arn | jq)
}

CLUSTER_ARN=$(aws kafka list-clusters-v2 --output text --query 'ClusterInfoList[*].ClusterArn')
echo "CLUSTER_ARN $CLUSTER_ARN"
for BROKER_ID in $(seq 1 3);
do
  echo "BROKER $BROKER_ID REBOOT STARTING"
  REBOOT_REQUEST=$(aws kafka reboot-broker --cluster-arn "$CLUSTER_ARN" --broker-ids "$BROKER_ID")
  
  #REBOOT_OPERATION_ARN="arn:aws:kafka:eu-central-1:220965329085:cluster-operation/devlvm-kafka/32d847a1-c28c-47bb-9d02-8dfb99f351b1-6/641c25d0-5076-4630-bb9f-561fa3a65dcc"
  REBOOT_OPERATION_ARN=$(echo "$REBOOT_REQUEST" | jq '.ClusterOperationArn')
  echo "REBOOT_OPERATION_ARN: $REBOOT_OPERATION_ARN"
  REBOOT_STATUS=$(getRebootStatus "$REBOOT_OPERATION_ARN")

  REBOOT_COMPLETE_STRING=$(echo '{"ClusterOperationInfo": {"OperationState": "REBOOT_COMPLETE"}}' | jq '.ClusterOperationInfo.OperationState')

  while [ "$(echo "$REBOOT_STATUS" | jq '.ClusterOperationInfo.OperationState')" != "$REBOOT_COMPLETE_STRING" ]; do
    echo "REBOOTING BROKER ${BROKER_ID}..."
    sleep 10
    REBOOT_STATUS=$(getRebootStatus "$REBOOT_OPERATION_ARN")
  done

  echo "BROKER ${BROKER_ID} REBOOT SUCCESS"
done

echo "-------- CLUSTER REBOOT COMPLETE --------"
