from datetime import datetime
from airflow.models import DAG
from datetime import timedelta
from airflow import DAG
from airflow.utils.dates import days_ago
from pathlib import Path
from airflow.providers.apache.druid.operators.druid import DruidOperator
from airflow.plugins_manager import AirflowPlugin
from airflow.providers.postgres.hooks.postgres import PostgresHook
import pandas as pd
from airflow.operators.python import PythonOperator
from textwrap import dedent

## placeholder for defining your extraction query(ries)
extract_query = 'SELECT * FROM Incident_claims_extended'
default_args = {
'owner': 'airflow',
'depends_on_past': False,
'start_date': days_ago(2),
'retries': 1,
'retry_delay': timedelta(minutes=5),
}
#Main declaration of DAG
with DAG(
dag_id='Group3',
default_args=default_args,
schedule_interval=None,
catchup=False,
tags=['Project2-Extension1'],
) as dag:
    dag.doc_md = __doc__

# [START extract_function]

def extract(**kwargs):
     task_instance = kwargs['ti']
     #customize with your implementation
     csv_path =kwargs[r'C:\Users\13658\Documents\Semester1\Data Management\Project\Fact_Table_extended.csv']
     pgHook = PostgresHook(postgres_conn_id=kwargs['postgres_conn_id'])
     pandas_df = pgHook.get_pandas_df(kwargs['sql'], parameters=kwargs['pandas_sql_params'])
     ## you add any additional operations on the pandas dataframe here
     csv_sep = ','

     if kwargs['csv_sep']:
         csv_sep = kwargs['csv_sep']
         #save to file
         pandas_df.to_csv(csv_path, sep=csv_sep)
         task_instance.xcom_push('raw_file', csv_path)
     # [END extract_function]

 


# [START transform_function]
def transform(**kwargs):
     task_instance = kwargs['ti']
     #customize with your implementation
     csv_path =kwargs['csv_path']
     fileName = task_instance.xcom_pull(task_ids='extract', key='raw_file')

     csv_sep = ','
     if kwargs['csv_sep']:
         csv_sep = kwargs['csv_sep']
         raw_data = pd.read_csv(fileName,sep=csv_sep)
         #perform any manipulation using pandas df here
         transformed = raw_data
         #save the output file to staging
         transformed.to_csv(csv_path, sep=csv_sep)
# [END transform_function]


# [START main_flow]
extract_task = PythonOperator(
task_id='extract',
python_callable=extract,
op_kwargs = {
"sql": "extract_query",
"postgres_conn_id":"pgoltp",
"pandas_sql_params": None,
"csv_path": '/tmp/filesystem/extract.csv',
"csv_sep":","
}
)
extract_task.doc_md = dedent()

transform_task = PythonOperator(
task_id='transform',
python_callable=transform,
op_kwargs = {
"csv_path": '/tmp/filesystem/transformed.csv',
"csv_sep":","
}
)
transform_task.doc_md = dedent()

# [START load_task]
load_task = PythonOperator(
        task_id='load',
        python_callable=load_druid,
        op_kwargs = {
            "druid_ingest_conn_id":"druid_ingest_default",
            "json_index_file":"druid-spec.json",
            "csv_path": '/tmp/filesystem/tranformed.csv',
            "csv_sep":","
        }
    )
load_task.doc_md = dedent()


extract_task >> transform_task >> load_task