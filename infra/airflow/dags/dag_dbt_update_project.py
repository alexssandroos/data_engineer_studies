from pendulum import datetime
import os
from airflow import DAG
from airflow.operators.empty import EmptyOperator
from cosmos.providers.dbt.task_group import DbtTaskGroup


with DAG(
    dag_id="dbt_update_models",
    start_date=datetime(2022, 11, 27),
    schedule="@daily",
):

    e1 = EmptyOperator(task_id="Start")

    workflow = DbtTaskGroup(
        group_id="workflow",
        dbt_project_name="beltrano",
        dbt_root_path="/opt/airflow/dags/dbt",
        conn_id="beltrano_dw",
        dbt_args={
            "db_name":"beltrano_dw",
            "schema": "stage",
            'dbt_executable_path': f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt"
        },
    )


    e2 = EmptyOperator(task_id="End")

    e1 >> workflow >> e2