**Note:** This is not an officially supported Google product. It is a reference implementation.

# MoDeM
MoDeM (Model Deployment for Marketing) is a **Google Cloud based ETL pipeline** for advertisers, interested in **ML-based audience retargeting**. The pipeline extracts user data from BigQuery, runs it through the desired machine learning model **(BigQueryML, scikit-learn, XGBoost, Tensorflow, AutoML)**, transforms the model predictions into an audience list, loading it into Google Analytics through Data Import, for **eventual activation in Google Ads, Display & Video 360 and Search Ads 360.** 

With marketers using increasingly sophisticated approaches in digital advertising, there has been an exponential increase in number of analysts, data scientists, and statisticians within marketing departments. While their mathematical modelling skills are second to none, the long-term success of ML projects hinge on making the jump from analysis to action. Often, analyst teams hack together a process, that can be extremely manual and error-prone with too many parameters, decoupled workflow dependencies and security vulnerabilities. In fact, an entire discipline called MLOps has emerged that focuses on operationaling machine learning workflows.    

MoDeM hopes to provide the **last-mile engineering infrastructure** that enables analysts to **quickly productionize & activate their models** with the necessary operational and security rigor. 

## Types of supported Model Deployment Infrastructures

1. **BigQueryML (BQML) models** deployed using Cloud Functions/Cloud Scheduler and Cloud Composer.
2. **Python ML models** built with scikit-learn, XGBoost & Tensorflow (Google AI Platform) using Cloud Functions/Cloud Scheduler and Cloud Composer.
3. **AutoML models** using Cloud Composer.

## Setup Instructions

1.. BigQueryML models using Cloud Functions/Cloud Scheduler - click [here](https://github.com/google/modem/blob/master/bqml/BQML_README.md)
