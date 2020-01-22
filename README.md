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
4. **Create a Google Cloud Storage (GCS) bucket:** In the Cloud Console, ***Storage > Browser > Create Bucket***. Save the bucket name, referred to as **<GCS_BUCKET_NAME>** ahead.

## Setup
### A. BigQueryML models using Cloud Functions/Cloud Scheduler

1. **Load the model in GCS:** Open a Cloud Shell. Replace **<GCS_BUCKET_NAME>** with the actual GCS bucket name and execute the following commands - 
    ``` 
    GCS_BUCKET="gs://<GCS_BUCKET_NAME>"
    git clone https://github.com/google/modem
    pushd modem/bqml/cloud_function
    zip -r bqml_cf.zip *
    gsutil cp bqml_cf.zip $GCS_BUCKET
    popd
    rm -rf modem
    ```
2. **Create the cloud function:** In the Cloud console, go to **Cloud Functions > Create** with the following parameters - 
    * **Memory allocated:** 2 GB
    * Uncheck **Allow unauthenticated invocations**
    * **Runtime:** Python 3.7
    * **Cloud Storage location:** <GCS_BUCKET_NAME>/bqml_cf.zip
    * **Function to execute:** main
    * (Click the ***'Environment variables, networking, timeouts and more'*** dropdown) **Timeout:** 540 (seconds)
    * (After successfully deploying the Cloud Function, check the security settings once again) In the **Cloud Functions** overview screen, select the function and check the Permissions tab on the right of the screen. **If it includes Cloud Function Invoker, please delete the allUsers member.** It is important to ensure authenticated access to the function. 

3. **Copy the service key credentials into svc_key.json file:** Open the Cloud Function and update the svc_key.json file with the details from the downloaded service key file (check Prerequisites - Step 2). 

4. **Edit the params.py file:** with the correct Google Analytics account id, property id, and dataset id. Also, update the query parameter with the BigQueryML predict query. 

5. **Schedule the function using the Cloud Scheduler:** You can either use the Cloud Console (Cloud Scheduler > Create Job) or use the Cloud Shell with the following parameters -
    * **JOBNAME:** Any name you like, e.g. ***"schedule_model_upload"***
    * **SCHEDULE:** Specify the schedule in a cron-tab format e.g. ***"* * * * *"*** for each minute
    * **TIMEZONE:** Choose a time-zone like ***"America/Detroit"***
    * **FUNCTION_URL:** The URL can be found ***within the Cloud Function > Trigger.*** It has the format ***"https://<PROJECT_ID>.cloudfunctions.net/<FUNCTION_NAME>"***
    * **SERVICE_ACCOUNT_EMAIL:** Service account email of the form ***"<SERVICE_ACCOUNT_NAME>@<PROJECT_ID>.iam.gserviceaccount.com"*** 
    
    ```
    JOBNAME=""
    SCHEDULE=""
    TIMEZONE=""
    FUNCTION_URL=""
    SERVICE_ACCOUNT_EMAIL=""
    gcloud alpha scheduler jobs create http $JOB_NAME  --schedule=$SCHDULE --uri=$FUNCTION_URL --time-zone=$TIMEZONE --oidc-service-account-email=$SERVICE_ACCOUNT_EMAIL
    ```
    




