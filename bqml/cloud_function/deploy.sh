echo "~~~~~~~~ Welcome ~~~~~~~~~~"
echo "Thanks for using BQML modem deployment." 
echo "---------------------------"
read -p "Please enter your GCP PROJECT ID: " project_id
echo "---------------------------"
read -p "Please enter your desired FUNCTION NAME: " function_name
echo "---------------------------"
echo "~~~~~~~~ Creating function ~~~~~~~~~~"
gcloud functions deploy $function_name --project $project_id --runtime python37 --memory 2GB --timeout 540s --trigger-http --entry-point trigger_workflow
