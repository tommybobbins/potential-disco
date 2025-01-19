# Provision a Google Cloud GCP GKE Autopilot Cluster

## Not for production use.
### Deployment

````
cd bootstrap
cat README.md
````
Read the README.md in there which will bootstrap the cluster through to the Github actions stages



# Accessing Argo post deployment

$ export KUBECONFIG=~/.kube/config
$ gcloud container clusters get-credentials $PROJECT_ID-gke --region europe-west2
Fetching cluster endpoint and auth data.
WARNING: cluster wibble-flibble-123456789-gke is not RUNNING. The kubernetes API may or may not be available. Check the cluster status for more information.

