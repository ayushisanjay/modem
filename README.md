**Note:** This is not an officially supported Google product. It is a reference implementation.

# MoDeM
MoDeM (Model Deployment for Marketing) is a **Google Cloud based ETL pipeline** for advertisers, interested in deploying **machine learning based user propensity models** for advanced audience retargeting. The pipeline extracts user data from BigQuery, runs it through the specified machine learning model **(BigQueryML, scikit-learn, XGBoost, Tensorflow, AutoML)**, transforms the predicted propensity score outputs into a consumable format for Google Analytics, loading it for **eventual activation in Google Ads, Display & Video 360 and Search Ads 360.** 

With marketers using increasingly sophisticated approaches in digital advertising, there has been an exponential increase in number of analysts, data scientists, and statisticians within marketing departments. While their mathematical modelling skills are second to none, the long-term success of ML projects hinge on making the jump from analysis to action. Often, analyst teams hack together a process, that can be extremely manual and error-prone with too many parameters, decoupled workflow dependencies and security vulnerabilities. In fact, an entire discipline called MLOps has emerged that focuses on operationaling machine learning workflows.    

MoDeM hopes to provide the **last-mile engineering infrastructure** that enables analysts to **quickly productionize & activate their models** with the necessary operational and security rigor. 

## Types of supported Model Deployment Infrastructures

1. **BigQueryML (BQML) models** deployed using Cloud Functions/Cloud Scheduler and Cloud Composer.
2. **Python ML models** built with scikit-learn, XGBoost & Tensorflow (Google AI Platform) using Cloud Functions/Cloud Scheduler and Cloud Composer.
3. **AutoML models** using Cloud Composer.

## Prerequisites
1. **Create service account key:** In the Cloud Console, ***IAM & Admin > Service Accounts > Create Service Account***. Fill out the necessary details, such as service account name, service account email, **permissions (BigQuery Job User)**, creating & downloading the key file. Please store the service account email & service key file safely. 
2. **Add the service account email as a user to Google Analytics:** Using the service account email generated from the previous step, create a user within ***Admin > Account > Account User Management*** with Edit, **Read and Analyze permissions**.
3. **Enable Google Analytics API:** In the Cloud Console, ***APIs & Services > Library***, search for **Google Analytics API,** not the Google Analytics Reporting API. 
4. (OPTIONAL) **Setup email API for failure alerts:** Setup Sendgrid API by creating a free account and downloading an **API Key** in the Settings section of the [SendGrid UI](https://sendgrid.com/docs/for-developers/sending-email/authentication/).

## Setup
### A. BigQueryML models using Cloud Functions/Cloud Scheduler

1. **Setup cloud function:** To create the cloud function, open a Cloud Shell and copy the following commands. Replace <GCP_PROJECT_ID> with GCP project ID which will run the BigQuery ML predict query & <FUNCTION_NAME> with a unique function name (don't use underscores). 
    ``` 
    GCP_PROJECT_ID="<GCP_PROJECT_ID>" && FUNCTION_NAME="<FUNCTION_NAME>"
    ```
    ```
    rm -rf modem && git clone https://github.com/google/modem.git && cd modem/bqml/cloud_function && gcloud functions deploy $FUNCTION_NAME --runtime python37 --memory 2GB --timeout 540s --trigger-http --entry-point trigger_workflow --project $GCP_PROJECT_ID && cd ../../../ && rm -rf modem
    ```
    
2. **Copy the service key credentials into svc_key.json file:** Edit the created Cloud Function in the UI and update the svc_key.json file with the details from the downloaded service key file (check Prerequisites - Step 2).

3. **Edit the params.py file:** with the correct Google Analytics account id, property id, and dataset id. Also, update the query parameter with the BigQueryML predict query.

4. (OPTIONAL) **Setup logging for the workflow in BigQuery:** Set up a **BigQuery table with the schema** - time TIMESTAMP, status STRING, error STRING. In params.py, set **ENABLE_BQ_LOGGING = True, GCP_PROJECT_NAME, BQ_DATASET_NAME, BQ_TABLE_NAME**.

5. (OPTIONAL) **Setup email alerts for workflow failures:**  In params.py, update **ENABLE_SENDGRID_EMAIL_REPORTING = True, SENDGRID_API_KEY and TO_EMAIL**. If desired, update the other relevant email setup params, such FROM_EMAIL, SUBJECT & HTML_CONTENT.

6. **Schedule the function using the Cloud Scheduler:** You can either use the Cloud Console (Cloud Scheduler > Create Job) or use the Cloud Shell with the required parameters in **scheduler.sh**.
