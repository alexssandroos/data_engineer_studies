from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.docker_operator import DockerOperator
from airflow.operators.python_operator import BranchPythonOperator
from airflow.operators.dummy_operator import DummyOperator
from docker.types import Mount
default_args = {
'owner'                 : 'airflow',
'description'           : 'hop-pipeline',
'depend_on_past'        : False,
'start_date'            : datetime(2022, 1, 1),
'email_on_failure'      : False,
'email_on_retry'        : False,
'retries'               : 1,
'retry_delay'           : timedelta(minutes=5)
}

with DAG('hop-pipeline', default_args=default_args, schedule_interval=None, catchup=False, is_paused_upon_creation=False) as dag:
    start_dag = DummyOperator(
        task_id='start_dag'
        )
    end_dag = DummyOperator(
        task_id='end_dag'
        )
    hop = DockerOperator(
        task_id='hop-dim_calendar-pipeline',
        # use the Apache Hop Docker image. Add your tags here in the default apache/hop: syntax
        image='apache/hop',
        api_version='auto',
        auto_remove=True,
        environment= {
            'HOP_RUN_PARAMETERS': 'INPUT_DIR=',
            'HOP_LOG_LEVEL': 'Basic',
            'HOP_FILE_PATH': '//project/dim/dim_calendar.hpl',
            'HOP_PROJECT_DIRECTORY': '//project',
            'HOP_PROJECT_NAME': 'beltrano',
            'HOP_ENVIRONMENT_NAME': 'beltrano-config.json',
            'HOP_ENVIRONMENT_CONFIG_FILE_NAME_PATHS': '/project/beltrano-config.json',
            'HOP_RUN_CONFIG': 'local'
        },
        docker_url="unix://var/run/docker.sock",
        network_mode="bridge",
        mounts=[Mount(source='/c/home/alexssandro_oliveira/projects/data_engineer_studies/infra/hop/beltrano', target='//project', type='bind'), Mount(source='/c/home/alexssandro_oliveira/projects/data_engineer_studies/infra/hop/beltrano/config', target='//project-config', type='bind')],
        force_pull=False
        )
    
start_dag >> hop >> end_dag