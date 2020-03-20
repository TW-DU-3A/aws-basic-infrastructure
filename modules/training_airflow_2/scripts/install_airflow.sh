set -x
yum -y groupinstall "Development Tools"
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel python-devel wget cyrus-sasl-devel.x86_64
yum -y install python-pip
pip install apache-airflow[s3]
airflow initdb
airflow scheduler -D
airflow webserver -D