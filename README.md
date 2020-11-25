# acm-hive-provision-yamls
## Working with this repository
### Edit cluster-templates
1. First decide which providers you want to use. If you want to use all three providers, then skip the next step
2. Delete the provider-install-config.yaml and cluster-provider.yaml files for providers you don't want to use. Example:
```bash
rm cluster-templates/azure-install-config.yaml
rm cluster-templates/cluster-azure.yaml
```
Also remove the deleted file references from `./kustomization.yaml`
3. Edit the `cluster-templates/PROVIDER-install-config.yaml` file
  * Add a value for ssh public key, to be used to connect to the cluster nodes
  * For **Azure** you must also add a value for `baseDomainResourceGroupName`
4. Edit the `cluster-templates/cluster-PROVIDER.yaml` file for each provider
  * Add value for `pull-secret`, `ssh-private-key` and `creds` (all of these are secrets)
  * The `creds` value(s) are different for each provider type
5. Values in the files you edited for 3 and 4 can be customized as you wish to template cluster deployments for your environments
6. Update the `*_BASEDOMAIN` variables in the `./deploy.sh` script

### Deploying clusters
1. Connect to the OpenShift cluster running Red Hat Advanced Cluster Management for Kubernetes
2. Run `./deploy.sh NAME_PREFIX VERSION` where NAME_PREFIX is combined with the PROVIDER type to make a name and VERSION is the OpenShift version that will be deployed. If you Hub cluster does not have a ClusterImageSet for the version you choose, the script will fail and provider you with a list of available versions.
3. Run `oc apply -k .` to provision the clusters. If you want this step to happen automatically, uncomment the last line in the `./deploy.sh` script
4. Alternately, you can modify the fully formed Cluster YAML's before you apply them
