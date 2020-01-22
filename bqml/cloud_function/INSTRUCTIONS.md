Instructions - 

1. Ensure that you've allocated at least 1 GB memory and set timeout to 540 seconds for the cloud function. 

2. Copy the service key file details into svc_key.json.

3. Updates params.py with relevant details. (Test the function before moving to the next step).

4. To schedule the cloud function, open the scheduler.sh and fill in the empty strings with the relevant details - 

<JOBNAME> = Any name you like, e.g.schedule_model_upload
<SCHEDULE> = Specify the schedule in a cron-tab format e.g. "* * * * *" for each minute
<TIMEZONE> = Specify the time-zone, e.g. America/Detroit

<FUNCTION_URL> = Check your specified function URL
<SERVICE_ACCOUNT_EMAIL> = Check your IAM settings. Ensure the svc_key.json details correspond to the right email

5. Once filled in with the relevant details, please open the Cloud Shell and run these commands.
