echo "~~~~~~~~ Welcome ~~~~~~~~~~"
echo "Thanks for using BQML modem deployment. Before starting, please ensure that your BQML predict query works from your selected project."
echo "---------------------------"
read -p "Please enter your desired FUNCTION NAME (Make sure it is unique and only has alphanumeric characters and -, e.g. hello-world1): " function_name
echo "~~~~~~~~ Creating function ~~~~~~~~~~"
gcloud functions deploy $function_name --runtime python37 --memory 2GB --timeout 540s --trigger-http --entry-point trigger_workflow
