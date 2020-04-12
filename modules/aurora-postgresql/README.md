## Terraform Configuration for RDS PostgresQL Module
This module provisions an Aurora Postgresql cluster. By default "skip_final_snapshot" is set to false so that a snapshot is taken when the cluster is destroyed.

### Module Files
The code is split into 4 files:
* **variables.tf**</br>
  Defines various variables used throughout the code.
* **outputs.tf**</br>
  Defines various variables whose contents are derived from the output of actions performed by the code itself.
* **postgres.tf**</br>
  Defines the variables of the aws modules required to create:
  * The Postgresql cluster and instances.
  * Required security groups to allow access to the cluster.
  * The snapshot that the cluster is created from.
* **scripts/get-latest-cluster-snapshot-id**</br>
  creates snapshot of the cluster before getting destroyed.

