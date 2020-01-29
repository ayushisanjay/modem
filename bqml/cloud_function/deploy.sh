echo "Thanks for using BQML modem deployment. Before starting, please ensure that your BQML predict query works from the project where you intend to deploy the cloud function."
read -p "Please enter your GCP PROJECT ID (This can sometimes be different than the name so please check before entering): " gcp_project_id
echo $gcp_project_id
read -p "Please enter your desired FUNCTION NAME (Make sure it is unique and only has alphanumeric characters and -, e.g. hello-world1): " function_name
echo $function_name
gcloud functions deploy $function_name --runtime python37 --memory 2GB --timeout 540s --trigger-http --entry-point trigger_workflow --project $gcp_project_id
