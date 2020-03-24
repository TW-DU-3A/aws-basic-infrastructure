#Install virtualenv and python3
sudo yum -y install python37 python3-pip
pip3 install -U virtualenv

python3 -m virtualenv airflow-python-3
cd airflow-python-3 && source bin/activate

set -x
yum -y groupinstall "Development Tools"
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel python3-devel wget cyrus-sasl-devel.x86_64 python3-setuptools gcc-c++

pip3 install apache-airflow

mkdir -p /root/airflow/plugins
mkdir -p /root/airflow/dags

wget -O /root/airflow/plugins/livy_hook.py https://raw.githubusercontent.com/JituS/spark-etl/master/airflow/plugins/livy_hook.py
wget -O /root/airflow/plugins/livy_sensor.py https://raw.githubusercontent.com/JituS/spark-etl/master/airflow/plugins/livy_sensor.py
wget -O /root/airflow/plugins/livy_operator.py https://raw.githubusercontent.com/JituS/spark-etl/master/airflow/plugins/livy_operator.py

wget -O /root/airflow/dags/sales-etl-job.py https://raw.githubusercontent.com/SwathiVarkala/spark-etl/master/airflow/dags/sales-etl-job.py

export INPUT_PATH=hdfs:///user/hadoop/swathiv/input
export RAW_PATH=hdfs:///user/hadoop/swathiv/raw
export DESTINATION_PATH=hdfs:///user/hadoop/swathiv/destination
export ERROR_PATH=hdfs:///user/hadoop/swathiv/error

airflow initdb
airflow scheduler -D
airflow webserver -D