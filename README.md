# Create a Grafana dashboard inside Kubernetes to examine the National Grid Power Mix

Project to create a grafana dashboard to scrape the National Energy System Operators Carbon Intesity Operator https://api.carbonintensity.org.uk/

## Provision a Google Cloud GCP GKE Autopilot Cluster

Not for production use.

### Bootstrapping

````
cd bootstrap
cat README.md
````
Read that README.md to see how to bootstrap the cluster through Github Actions.

# Argo Setup

Once the Github actions have run, replace the SecretsManager secrets with the URL of the repository and your PAT token

````
{"gh_pat_token":"REPLACE ME!","url":"https://github.com/tommybobbins/potential-disco"}
````

### Accessing Argo post deployment

Gain Kubernetes Cluster credentials

````
$ export KUBECONFIG=~/.kube/config
$ export KUBE_CONFIG_PATH=${KUBECONFIG}

$ gcloud container clusters get-credentials $PROJECT_ID-gke --region europe-west2
Fetching cluster endpoint and auth data.
WARNING: cluster wibble-flibble-123456789-gke is not RUNNING. The kubernetes API may or may not be available. Check the cluster status for more information.
````


Access Argo using Port forwarding
````
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echoho

StringofAdminPasswordReturned

$ kubectl port-forward svc/argocd-server -n argocd 8080:443
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
````

![Argo Login](./bootstrap/images/argo_login.png)

