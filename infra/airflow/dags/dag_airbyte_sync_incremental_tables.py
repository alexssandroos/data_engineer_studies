from datetime import datetime, timedelta
from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.dummy_operator import DummyOperator
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator

default_args = {
'owner'                 : 'airflow',
'description'           : 'airbyte-sync-incremental-tables',
'depend_on_past'        : False,
'start_date'            : datetime(2022, 1, 1),
'email_on_failure'      : False,
'email_on_retry'        : False,
'retries'               : 1,
'retry_delay'           : timedelta(minutes=5)
}


with DAG(dag_id='airbyte_trigger_incremental_load_tables',
         default_args=default_args,
         schedule_interval='@daily',
         start_date=days_ago(1)
    ) as dag:
    
    start_dag = DummyOperator(
        task_id='start_dag'
        )
    end_dag = DummyOperator(
        task_id='end_dag'
        )
    sync_tables_incremental = AirbyteTriggerSyncOperator(
        task_id='airbyte_sync_tables_incremental',
        airbyte_conn_id='airbyte_local',
        connection_id='add6aef9-57af-4ad3-b7ee-392fce5d1758',
        asynchronous=True,
    )


    start_dag >> sync_tables_incremental  >> end_dag