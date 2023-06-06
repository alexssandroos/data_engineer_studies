FROM apache/airflow:2.6.0
ADD requirements.txt .

# cosmos requirements
# install dbt into a venv to avoid package dependency conflicts
ENV PIP_USER=false
RUN python3 -m venv ${AIRFLOW_HOME}/dbt_venv
RUN ${AIRFLOW_HOME}/dbt_venv/bin/pip install dbt-postgres==1.5.0
ENV PIP_USER=true

RUN pip install --upgrade pip && pip install -r requirements.txt
