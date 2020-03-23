#Install virtualenv and python3
sudo yum install python37 python-pip
pip install -U pip
pip install -U virtualenv
virtualenv -p python3 airflow-python-3
cd airflow-python-3 && source bin/activate

set -x
yum -y groupinstall "Development Tools"
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel python-devel wget cyrus-sasl-devel.x86_64

pip install apache-airflow[s3]
airflow initdb
airflow scheduler -D
airflow webserver -D