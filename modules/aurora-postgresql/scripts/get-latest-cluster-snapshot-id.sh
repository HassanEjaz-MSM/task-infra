#!/bin/sh
if [ $# -eq 0 ]; then
    echo "A cluster id is required"
    exit 1
fi
cluster_id=$1

snapshot=$(aws --region us-east-1 rds describe-db-cluster-snapshots --db-cluster-identifier ${cluster_id} --query="reverse(sort_by(DBClusterSnapshots, &SnapshotCreateTime))[0] |DBClusterSnapshotIdentifier" --output text)
case ${snapshot} in
  'none')
    echo "{ \"snapshot\": \"\" }"
    ;;
  'None')
    echo "{ \"snapshot\": \"\" }"
    ;;
  *)
    echo "{ \"snapshot\": \"${snapshot}\" }"
    ;;
esac
exit 0
