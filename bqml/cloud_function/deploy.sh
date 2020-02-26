echo "~~~~~~~~ Welcome ~~~~~~~~~~"
echo "Thanks for using BQML modem deployment." 
echo "---------------------------"
read -p "Please enter your GCP PROJECT ID: " project_id
echo "---------------------------"
read -p "Please enter your desired FUNCTION NAME: " function_name
echo "---------------------------"
echo "~~~~~~~~ Creating function ~~~~~~~~~~"
svc_account_email=`gcloud iam service-accounts list --filter="App Engine default service account" | awk 'FNR == 2{print $6}'` 
sed_expr='s/SERVICE_ACCOUNT_EMAIL=""/SERVICE_ACCOUNT_EMAIL="'$svc_account_email'"/'
echo `sed $sed_expr scheduler.sh` > scheduler.sh
gcloud functions deploy $function_name --project $project_id --runtime python37 --memory 2GB --timeout 540s --trigger-http --entry-point trigger_workflow
