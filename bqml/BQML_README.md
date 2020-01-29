# Deploying BQML models

## Workflow Prerequisities
1. **Create service account key:** In the Cloud Console, ***IAM & Admin > Service Accounts > Create Service Account***. Fill out the necessary details, such as service account name, service account email, **permissions (BigQuery Job User)**, creating & downloading the key file. Please store the service account email & service key file safely. 
2. **Enable Google Analytics API:** In the Cloud Console, ***APIs & Services > Library***, search for **Google Analytics API,** not the Google Analytics Reporting API. 
3. (OPTIONAL, if using Cloud Functions) **Setup email API for failure alerts:** Setup Sendgrid API by creating a free account and downloading an **API Key** in the Settings section of the [SendGrid UI](https://sendgrid.com/docs/for-developers/sending-email/authentication/).

## Account Setup
1. **Add the service account email as a user to Google Analytics:** Using the service account email generated from the previous step, create a user within ***Admin > Account > Account User Management*** with Edit, **Read and Analyze permissions**.

## Test Data Setup
If you wish to play around with the workflow, please use the sample data included. 

## Workflow Setup
### A. BigQueryML models using Cloud Functions/Cloud Scheduler

**IMPORTANT:** Before you start, please make sure you select the right project in the Cloud Console.

1. **Setup cloud function:** To create the cloud function, open a Cloud Shell and copy the following command. Follow the instructions that appear on the screen. 
    ```
    rm -rf modem && git clone https://github.com/google/modem.git && cd modem/bqml/cloud_function && sh deploy.sh
    ```
    
2. ***(OPTIONAL)* Setup logging for the workflow in BigQuery:** Set up a **BigQuery table with the schema** - *time TIMESTAMP, status STRING, error STRING*. To create a dataset with name 'workflow' and table name 'logs', please run the command below-
    ```
    DATASET_NAME="workflow" && TABLE_NAME="logs" && bq mk --dataset $DATASET_NAME && bq mk --table $DATASET_NAME.$TABLE_NAME time:TIMESTAMP,status:STRING,error:STRING
    ```
3. **Edit 'svc_key.json' file:** Edit the created Cloud Function in the UI and update the svc_key.json file with the details from the downloaded service key file (check Prerequisites - Step 2).

3. **Edit 'params.py' file:** with the correct Google Analytics account id, property id, and dataset id. Also, update the query parameter with the BigQueryML predict query. ***Optionally***, if you choose to enable monitoring, set **ENABLE_BQ_LOGGING = True, GCP_PROJECT_ID, BQ_DATASET_NAME, BQ_TABLE_NAME**. Also, if you choose to receive email alerts for failures, set **ENABLE_SENDGRID_EMAIL_REPORTING = True, SENDGRID_API_KEY and TO_EMAIL**. Other params, such FROM_EMAIL, SUBJECT & HTML_CONTENT, work with default values but feel free to edit.

4. **Edit 'scheduler.sh' file:** with JOB_NAME, SCHEDULE, TIMEZONE, FUNCTION_URL & SERVICE_ACCOUNT_EMAIL as specified and "Deploy" the function. 

5. **Schedule the function using the Cloud Scheduler:** You can either use the Cloud Console (Cloud Scheduler > Create Job) or use the Cloud Shell by copying the commands from the edited 'scheduler.sh' file (lines 30 - 35).

