# README

```zsh
kubectl run --rm -ti -n default kafka-client \
    --image=ghcr.io/innovations-on-gmbh/docker-aws-maintenance/kafka-client:latest \
    --env="PASSWORD=$(sops -d --extract '["kafka"]["config_user"]["password"]' ~/onpier/onpier-onpier/terraform-software-onpier/environments/dev/credentials.yaml)" \
    --env="BOOTSTRAP=$(aws kafka list-clusters-v2 --output text --query 'ClusterInfoList[*].ClusterArn' | xargs -I {} aws kafka get-bootstrap-brokers --cluster-arn {} --output text)" \
    --env="CLUSTER_ARN=$(aws kafka list-clusters-v2 --output text --query 'ClusterInfoList[*].ClusterArn')" \
    --image-pull-policy=Always --overrides='{"metadata": {"annotations": { "linkerd.io/inject":"disabled" } } }'
```

```zsh
export DNS_ZONE=test.de
kafka-configs.sh --bootstrap-server "b-1.$DNS_ZONE:9096" --entity-type brokers --entity-name 1 --command-config /config.properties --all --describe
```
