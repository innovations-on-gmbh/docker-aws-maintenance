# README

```zsh
kubectl run --rm -ti -n default kafka-client --image=ghcr.io/innovations-on-gmbh/docker-aws-maintenance/kafka-client:0.1 --env="CONFIG_USER=$(sops -d --extract '["kafka"]["config_user"]["password"]' credentials.yaml)" --env="BOOTSTRAP=$(aws kafka list-clusters-v2 --output text --query 'ClusterInfoList[*].ClusterArn' | xargs -I {} aws kafka get-bootstrap-brokers --cluster-arn {} --output text)"
```
