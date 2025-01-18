# Provision a Google Cloud GCP GKE Autopilot Cluster for CAPA (Certified Argo Project Associate)

## Not for production use.


### Deployment

Check that all the APIs are enabled
```
$ ./create_apis.sh
$ gcloud services list --enabled
NAME                                 TITLE
appengine.googleapis.com             App Engine Admin API
appenginereporting.googleapis.com    App Engine
autoscaling.googleapis.com           Cloud Autoscaling API
bigquerystorage.googleapis.com       BigQuery Storage API
certificatemanager.googleapis.com    Certificate Manager API
cloudapis.googleapis.com             Google Cloud APIs
cloudbuild.googleapis.com            Cloud Build API
cloudresourcemanager.googleapis.com  Cloud Resource Manager API
cloudscheduler.googleapis.com        Cloud Scheduler API
cloudtrace.googleapis.com            Cloud Trace API
compute.googleapis.com               Compute Engine API
container.googleapis.com             Kubernetes Engine API
containerregistry.googleapis.com     Container Registry API
datastore.googleapis.com             Cloud Datastore API
deploymentmanager.googleapis.com     Cloud Deployment Manager V2 API
iam.googleapis.com                   Identity and Access Management (IAM) API
iamcredentials.googleapis.com        IAM Service Account Credentials API
logging.googleapis.com               Cloud Logging API
monitoring.googleapis.com            Cloud Monitoring API
oslogin.googleapis.com               Cloud OS Login API
secretmanager.googleapis.com         Secret Manager API
servicemanagement.googleapis.com     Service Management API
serviceusage.googleapis.com          Service Usage API
```

Create a tofu.tfvars file containing something similar to the following:

    credentials_file  = "wibbly-flibble-stuff-morestuff.json"
    project           = "wibble-flibble-numbers"
    region            = "europe-west2"

Example for creating service account
````
$ export PROJECT_ID=wibble-flibble-123456
$ gcloud config set project $PROJECT_ID
$ gcloud auth application-default login
$ gcloud config set project ${PROJECT_ID}
$ gcloud storage buckets create gs://${PROJECT_ID}-terraform --project $PROJECT_ID --location europe-west2
$ gcloud iam service-accounts create tofu-deployer
$ gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:tofu-deployer@${PROJECT_ID}.iam.gserviceaccount.com" --role=roles/editor
````

Create the service account keys which will be used for tofu wibbly-flibble-stuff-morestuff.json using:

````
    $ gcloud iam service-accounts keys create gcp_deployment_creds.json  \
    --iam-account=tofu-deployer@${PROJECT_ID}.iam.gserviceaccount.com
created key [123456abcdef1234] of type [json] as [gcp_deployment_creds.json] for [tofu-deployer@wibble-flibble-123456.iam.gserviceaccount.com]
````

Run the standard terraform deployment:
   ```
   $ tofu init
   $ tofu plan
   $ tofu apply
   ```

For the bootstrap enabling apis, some have to be imported manually:
````
$ tofu state rm "google_project_service.service[\"oslogin.googleapis.com\"]"
$ tofu state rm "google_project_service.service[\"iamcredentials.googleapis.com\"]"
$ tofu import "google_project_service.service[\"oslogin.googleapis.com\"]" "${PROJECT_ID}/oslogin.googleapis.com"
$ tofu import "google_project_service.service[\"iamcredentials.googleapis.com\"]" "${PROJECT_ID}/iamcredentials.googleapis.com"
$ tofu apply



This will create everything except the kubectl_manifests which must be created after getting the cluster credentials These will be generated on a second tofu apply once the kubernetes cluster credentials have been found.
Run the below command to populate the ~/.kube/config:

    $ gcloud container clusters get-credentials <project_name>-gke --region europe-west2

Set the kubeconfig for Helm
 
    $ export KUBE_CONFIGFILE=$KUBECONFIG

Run tofu apply again which should output:

```
helm_release.argocd: Still creating... [3m20s elapsed]
helm_release.argocd: Creation complete after 3m24s [id=argocd]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

kubernetes_cluster_host = "1.2.3.4"
kubernetes_cluster_name = "wibbly-bibbly-12235-gke"
project = "wibbly-bibbly-12235"
region = "europe-west2"
```
### Lab 3.1  Installing ArgoCD
Enable ArgoCD
````
$ echo "argocd_enabled = true" >> terraform.tfvars
$ tofu apply
````
````
$ kubectl port-forward svc/argocd-server -n argocd 8080:443
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
````
### Lab 4.1  Installing Argo Workflows

Enable Argo workflows by editing the terraform.tfvars so that is looks like the below:
````
argocd_enabled        = false
argoworkflows_enabled = true
````
Re-run the tofu

````
$ tofu apply
````
Port forward to the workflows server
````
$ kubectl -n argo port-forward deployment/argo-workflows-server 2746:2746
$ kubectl create rolebinding default-admin --clusterrole=admin --serviceaccount=argo:default -n argo
rolebinding.rbac.authorization.k8s.io/default-admin created
$ kubectl create -f workflows/dag-workflow-template.yaml
workflowtemplate.argoproj.io/whalesay-template created
$ kubectl create -f workflows/dag-workflow.yaml 
workflow.argoproj.io/dag-diamond-zrwsl created
$ kubectl get workflowtemplates
No resources found in default namespace.
$ kubectl get workflowtemplates -n argo
NAME                AGE
whalesay-template   12s
$ kubectl get workflows -n argo
NAME                STATUS    AGE   MESSAGE
dag-diamond-zrwsl   Running   13s   
$ kubectl get workflows -n argo
NAME                STATUS    AGE   MESSAGE
dag-diamond-zrwsl   Running   15s 
````

### Lab 5.1  Installing Argo Rollouts

Enable Argo Rollouts by editing the terraform.tfvars so that is looks like the below:
````
argocd_enabled        = false
argoworkflows_enabled = false
argorollouts_enabled  = true
````
Re-run the tofu

### Lab 6.1

````
#$ kubectl create -f events/install.yaml
$ kubectl create -f events/install-validating-webhook.yaml 
$ kubectl create -f -n argo-events events/native.yaml 
$ kubectl create -f -n argo-events events/webhook.yaml 
$ kubectl create -f -n argo-events events/sensor-rbac.yaml 
$ kubectl create -f -n argo-events events/workflow-rbac.yaml 
$ kubectl create -f -n argo-events events/webhook-sensors.yaml 
$ ./events/expose-webhook.sh
````
