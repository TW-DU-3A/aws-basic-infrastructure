export PATH=/usr/local/lib/python2.7/site-packages/airflow/bin:$PATH
airflow initdb
airflow webserver -D -p 8090
